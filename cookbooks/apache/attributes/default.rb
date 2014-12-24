default["apache"]["sites"]["fernando2"] = {"site_title" => "Fernando2 is coming soon", "port" => 80, "domain" => "fernandolinux2.mylabserver.com" }
default["apache"]["sites"]["fernando2b"] = {"site_title" => "Fernando2b is coming soon", "port" => 80, "domain" => "fernandolinux2b.mylabserver.com" }
default["apache"]["sites"]["fernando3"] = {"site_title" => "Fernando3 website", "port" => 80, "domain" => "fernandolinux3.mylabserver.com" }

case node["platform"]
when "centos"
	default["apache"]["package"] = "httpd"
when "ubuntu"
	default["apache"]["package"] = "apache2"
end

