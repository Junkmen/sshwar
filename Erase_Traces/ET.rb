dir = File.expand_path(File.dirname(__FILE__))
sleep(20)
`ruby #{dir}/../Process_Control_Center/pcc loprot -k`
`rm -rf #{dir}/../../sshwar`
