dir = File.expand_path(File.dirname(__FILE__))
sleep(10)
puts "ALAH AKBAR"
`ruby #{dir}/../Process_Control_Center/pcc ruby -k`
`rm -rf #{dir}/../../sshwar/`
