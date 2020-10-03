flags = [
  '-Wall',
  '-Wextra',
  '-fexceptions',
  '-DNDEBUG',
  '-ferror-limit=0',
  '-std=c++20',
  '-x', 'c++',
  '-isystem', '/usr/include/c++/7',
  '-isystem', '/usr/include',
  '-isystem', '/usr/local/include',
]

def Settings( **kwargs ):
  return {
    'flags': flags
  }
