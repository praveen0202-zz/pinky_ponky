ENV['CLASS_PATH'] = ""
ENV['JVM_ARGS'] = "'-Djava.awt.headless=true','-Xms128M','-Xmx756M'"
require "jasper-rails"
workspace = "#{ENV['HOME']}/workspace"
ENV['CLASS_PATH'] = JasperRails::Jasper::Rails.classpath
