#!/usr/bin/env ruby

require_relative "../lib/diggo_clipper"

driver = DiggoClipper::DriverFactory.create
DiggoClipper::Authentication.new(driver).login
DiggoClipper::Clipper.new(driver).start
sleep 360
driver.quit
