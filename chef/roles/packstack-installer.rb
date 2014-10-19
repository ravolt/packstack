name "packstack-installer"
description "Setup an environment to run packstack"
run_list('recipe[packstack::installer]')
