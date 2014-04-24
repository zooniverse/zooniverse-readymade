flags = ['dev']

module.exports = {}

for flag in flags
  module.exports[flag] = parseFloat location.search.match("#{flag}=(\\d+)")?[1]
