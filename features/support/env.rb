require 'aruba/cucumber'
require 'open3'

Before do
  @aruba_timeout_seconds = 30
  @aruba_io_wait_seconds = 30
end