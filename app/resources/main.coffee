# WTF: Why aren't these being resolved?
require 'zooniverse/views/zooniverse-logo-svg'
require 'zooniverse/views/group-icon-svg'
require 'zooniverse/views/language-icon-svg'
require 'zooniverse/views/mail-icon-svg'

window.jQuery = require 'jquery'

Project = require '../../src/project'

window.zooniverseProject = new Project window.zooniverseProjectConfig
