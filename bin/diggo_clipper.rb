#!/usr/bin/env ruby

require_relative "../lib/diggo_clipper"

driver = DiggoClipper::DriverFactory.create
DiggoClipper::Authentication.new(driver).login
sleep 10
driver.quit
