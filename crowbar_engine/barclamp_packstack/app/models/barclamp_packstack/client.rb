

class BarclampPackstack::Client < Role

  def sysdata(nr)
    # Find installers
    the_installers = []
    installer_role = Role.find_by(name: 'packstack-installer')
    installer_role.node_roles.each do |mnr|
      the_installers << mnr if (mnr.deployment == nr.deployment)
    end

    # get the_installers keys
    keys = {}
    the_installers.each do |tnr|
      tip = Attrib.get("packstack-public_key", tnr)
      if tip
        keys[tnr.node.name] = tip
      end
    end

    {
      "packstack" => {
        "public_keys" => keys
      }
    }
  end

end

