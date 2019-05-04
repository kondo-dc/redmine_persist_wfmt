Redmine::Plugin.register :redmine_persist_wfmt do
  name 'Redmine persist wiki format plugin'
  author 'pinzolo'
  description 'This is a plugin for Redmine that persists wiki format'
  version '2.0.0'
  url 'https://github.com/pinzolo/redmine_persist_wfmt'
  author_url 'https://github.com/pinzolo'
end

require_relative 'lib/pwfmt'
