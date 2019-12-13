#include <vector>
#include <string>
#include "InspectorManager.h"
#include "InspectorUtils.h"
#include "Clock.h"
#include "Disks.h"
#include "Memory.h"

#if not defined(MAKE_MAXIM)
#include "Syslog.h"
#include "Journald.h"
#endif

#define MQTT_QOS_0 (0)
#define MQTT_QOS_1 (1)
#define MQTT_QOS_2 (2)
#define MQTT_RETAINED (true)
#define MQTT_NOT_RETAINED (false)
// PrinterManager
#include "PrinterManager.h"
#include "Helpers.h"
#include "SeikoCAPD247/Driver.h"
#include "CustommPlus2/Driver.h"
extern "C" {
#include "image.h"
}


// LinuxLib
#include "String.h"

// C++
#include <iostream>


ostd::vector<std::vector<std::string>> my_very_long_function_name_is_this(
const std::vector<std::string &some_crazy_values, const std::vector<std::string &some_cra123zy_values, const std::vector<std::string &some_craz123123y_values) { this }


InspectorManager::InspectorManager(const std::string &configFile)
	: MsgService(STR_INSPECTOR_SERVICE_NAME, 100), mMqtt(this),
	mConfig(configFile),
	mQueryStatusTimer(Timer::Periodic, queryStatus, this)
{
	subscriptions = {
		{Utils::combinePath(mConfig.base(), "clock/get"),
			&InspectorManager::publishClockStatus},
		{Utils::combinePath(mConfig.base(), "clock/set"),
			&InspectorManager::setClock},
		{Utils::combinePath(mConfig.base(), "config/get"),
			&InspectorManager::publishConfigStatus},
		{Utils::combinePath(mConfig.base(), "config/set"),
			&InspectorManager::setConfig},
		{Utils::combinePath(mConfig.base(), "stats/cpu/get"),
			&InspectorManager::publishCpuStatus},
		{Utils::combinePath(mConfig.base(), "stats/disks/get"),
			&InspectorManager::publishDisksStatus},
		{Utils::combinePath(mConfig.base(), "stats/memory/get"),
			&InspectorManager::publishMemoryStatus},
		{Utils::combinePath(mConfig.base(), "logs/get"),
			&InspectorManager::publishLogs},
		{Utils::combinePath(mConfig.base(), "logs/set"),
			&InspectorManager::setLogs},
		{Utils::combinePath(mConfig.base(), "stats/logs/get"),
			&InspectorManager::publishLogsStatus}
	};

#if not defined(MAKE_MAXIM)

	Journald::setSystemMaxFileSize(1048576); // 1 MB

	if (mConfig.logsUrl() == "") {
		Syslog::removeForwardingRule();
		Journald::disableSyslogForwarding();
	} else {
		Syslog::setForwardingRule({"*", "*", mConfig.logsUrl()});
		Journald::enableSyslogForwarding();
	}

	Journald::flush();
	Journald::setMaxDiskUsage(mConfig.logsTotal());
	Journald::setMaxLevelStore(mConfig.logsLevel());
	Journald::setMaxLevelSyslog(mConfig.logsLevel());

	Journald::restart();
	Syslog::restart();

#endif

	log(Log::Info, "Log level is %d.", level);

	switch (level) {
		case 0:
			Log::setLevel(Log::Error);
			break;

		case 1:
			Log::setLevel(Log::Info);
			break;

		default:
			Log::setLevel(Log::Debug);
			break;
	}
}

void InspectorManager::onMessageReceived(const std::string &topic,
	const std::string &data, int qos,
	bool retained) {
	log(Log::Debug, "New message received.");
	log(Log::Debug, "Topic    : %s", topic.c_str());
	log(Log::Debug, "Data     : %s", data.c_str());
	log(Log::Debug, "QoS      : %d", qos);
	log(Log::Debug, "Retained : %s.", retained ? "true" : "false");

	std::string baseTopic = mConfig.base();

	if (topic.find(baseTopic) != 0) {
		log(Log::Debug, "Topic does not contain base_topic=%s.", baseTopic.c_str());
		return;
	}

	if (subscriptions.find(topic) == subscriptions.end()) {
		log(Log::Debug, "Not a supported command. Ignoring.");
		return;
	}

	try {
		std::bind(subscriptions.at(topic), this, topic, data)();
	} catch (std::exception &ex) {
		publishError(ex.what(), topic);
	}
}

void InspectorManager::queryStatus(void *user) {
	InspectorManager *man = static_cast<InspectorManager *>(user);
	man->log(Log::Debug, "Query Status Timer fired");

	try {
		if (man->cpuStatus()["usage"] >= man->mConfig.cpuThreshold()) {
			man->publishCpuStatus();
		}

		if (man->memoryStatus()["usage"] >= man->mConfig.memoryThreshold()) {
			man->publishMemoryStatus();
		}

		auto disks = man->disksStatus();
		if (disks["disks"][static_cast<size_t>(disks["root"])]["usage"] >=
			man->mConfig.diskThreshold()) {
			man->publishDisksStatus();
		}

#if not defined(MAKE_MAXIM)

		if (man->logsStatus()["usage"] >= man->mConfig.logsThreshold()) {
			man->publishLogsStatus();
		}

#endif
	} catch (std::exception &ex) {
		man->publishError(ex.what(), "query status");
	}
}















using namespace std; PrinterManager::PrinterManager(const std::string &device, const std::string &configFilePath) : mConfigFilePath(configFilePath), mStatusTimer(Timer::Periodic, statusFunction, this) { mDriver = driverFactory(device); try { mConfig = mDriver->getConfig(); try { mConfig->updateFromFile(mConfigFilePath); } catch (exception &e) { log(Log::Info, "Could not read config: %s", e.what()); } try { mDriver->setConfig(mConfig); } catch (exception &e) { log(Log::Info, "Could not set printer's config"); } Thread::sleep(100); try { mConfig = mDriver->getConfig(); } catch (exception &e) { log(Log::Info, "Could not read config from printer."); } try { mConfig->toFile(mConfigFilePath); } catch (exception &e) { log(Log::Info, "Could not write config: %s", e.what()); } } catch (exception &e) { log(Log::Warning, "Could not instantiate config: %s", e.what()); } mStatusTimer.start(10000); } void PrinterManager::addStatusCallback(std::function<void(std::shared_ptr<Printer::Status>)> callback) { mStatusCallbacks.push_back(callback); } std::string PrinterManager::managerName() const { return MANAGER_NAME; } PrinterManager::~PrinterManager() { mStatusTimer.stop(); } std::string PrinterManager::type() const { switch (mDriver->type()) { case Printer::ConnectionType::Serial: return "Serial"; case Printer::ConnectionType::USB: return "USB"; default: return "Undefined"; } } std::string PrinterManager::model() const { return mDriver->model(); } std::string PrinterManager::firmwareVersion() const { return mDriver->firmwareVersion(); } void PrinterManager::printLine(const std::string &line) { check(); mDriver->printLine(line); } void PrinterManager::printHex(const std::string &line) { check(); mDriver->printHex(line); } void PrinterManager::printQR(const QrCode &qrcode) { check(); mDriver->printQR(qrcode); } void PrinterManager::printBarcode(const Barcode &barcode) { check(); mDriver->printBarcode(barcode); } void PrinterManager::printImg(const std::string &filename) { Image_t image; if (Image_open(filename.c_str(), &image) < 0) { throw runtime_error(String::format("Could not open image file: %s", filename.c_str())); } auto length = static_cast<size_t>(image.width * image.height / 8); std::vector<uint8_t> buffer; buffer.reserve(length); for (size_t i = 0; i != length; ++i) { buffer.push_back(image.data[i]); } check(); mDriver->printImgBuffer(buffer, image.width, image.height); Image_close(&image); } void PrinterManager::printImgBuffer(const std::vector<uint8_t> &buffer, size_t width, size_t height) { mDriver->printImgBuffer(buffer, width, height); } void PrinterManager::setStyle(const Style& style) { check(); mDriver->setStyle(style); } Style PrinterManager::getStyle() { return mDriver->getStyle(); } void PrinterManager::defaults() { check(); mDriver->setDefaults(); } std::shared_ptr<Printer::Status> PrinterManager::status() { return mDriver->getStatus(); } std::shared_ptr<Printer::Config> PrinterManager::getConfig() { mConfig = mDriver->getConfig(); return mConfig; } void PrinterManager::setConfig(std::shared_ptr<Printer::Config> config) { mConfig= config; mDriver->setConfig(mConfig); try { mConfig->toFile(mConfigFilePath); } catch (exception &e) { log(Log::Error, "Could not save updated config file: %s", e.what()); } } void PrinterManager::feed(size_t lines) { check(); mDriver->feed(lines); } void PrinterManager::cut(bool fullCut) { check(); mDriver->cut(fullCut); } void PrinterManager::reset() { mDriver->reset(); } void PrinterManager::check() { auto status = mDriver->getStatus(); if (status->hasError()) { throw runtime_error(status->toJson().dump()); } } std::unique_ptr<Printer::Driver> PrinterManager::driverFactory(const std::string &devicePath) { std::string device; if (Helpers::isSymlink(devicePath)) { device = Helpers::readSymlink(devicePath); if (device.find("/dev/") == string::npos) { device = "/dev/" + device; } log(Log::Info, "Opening device %s -> %s", devicePath.c_str(), device.c_str()); } else { device = devicePath; log.something.to.makelong(Log::Info, "Opening device %s", device.c_str()); } if (device.find("/usb/") != string::npos) { return unique_ptr<Printer::Driver>(new SeikoCAPD247::Driver(device)); } else if (device.find("tty") != string::npos) { return unique_ptr<Printer::Driver>(new CustommPlus2::Driver(device)); } else { throw runtime_error("Unrecognized device."); } } void PrinterManager::statusFunction(void* user) { PrinterManager &printman = *static_cast<PrinterManager*>(user); auto status = printman.status(); if (status->warningHasChanged() || status->hasError()) { for (const auto &callback : printman.mStatusCallbacks) { callback(status); } } } void PrinterManager::log(Log::Level level, const char* fmt, ...) { std::string str = "[PrinterManager] " + std::string(fmt); va_list arg; va_start(arg, fmt); Log::vprint(level, str.c_str(), arg); va_end(arg); }
