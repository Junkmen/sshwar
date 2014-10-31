def hide(content)
	count1 = 0
	count2 = 0
	password1 = ARGV[2]
	if ARGV[3] != nil
		password2 = ARGV[3]
	else
		password2 = "DEFAULT"
	end
	encrypt = Array.new

	content.each_char do |c|
		c_code = c.ord.to_i
		#Encryption formula:
		c_code = c_code + password1[count1].ord * 2 + password2[count2].ord * password1[count1].ord - 10
		encrypt << c_code
		count1 += 1
		count2 += 1
		count1 = 0 if count1 == password1.length
		count2 = 0 if count2 == password2.length
	end
	return encrypt
end

def reveal(content)
	count1 = 0
	count2 = 0
	password1 = ARGV[2]
	if ARGV[3] != nil
		password2 = ARGV[3]
	else
		password2 = "DEFAULT"
	end
	decrypt = ""
	content = content.split("\n")
	content.each do |el|
		code = el.to_i
		#Decryption formula:
		code = code - (password1[count1].ord * 2 + password2[count2].ord * password1[count1].ord) + 10
		decrypt << code.chr
		count1 += 1
		count2 += 1
		count1 = 0 if count1 == password1.length
		count2 = 0 if count2 == password2.length
	end
	return decrypt
end

def hideImplement(target, check)
	abort("File \"#{target}\" does not exist!") if not File.file?(target) 
	content = File.read(target)
	content = hide(content)
	command = "yes"
	if check == true
		puts "Are you sure you want to encrypt \"#{target}\" with passwords: \"#{ARGV[2]}\" \"#{ARGV[3]}\"? (yes/no)"
		command = STDIN.gets.chomp
	end
	if command == "yes"
		outfile = File.new(target, "w")
		outfile.puts(content)
		outfile.close
		puts "Target \"#{target}\" successfully encryped with passwords: \"#{ARGV[2]}\" \"#{ARGV[3]}\""
	end
end

def revealImplement(target, check)
	abort("File \"#{target}\" does not exist!") if not File.file?(target) 
	content = File.read(target)
	content = reveal(content)
	command = "yes"
	if check == true
		puts "Target \"#{target}\" contains:"
		puts content
		puts "Are you sure to proceed to decryptation? (yes/no)"
		command = STDIN.gets.chomp
	end
	if command == "yes"
		outfile = File.new(target, "w")
		outfile.puts(content)
		outfile.close
		puts "Target \"#{target}\" was successfully decrypted!"
	end
end

if ARGV[0] == nil
	puts "gSS v1.0"
	puts "Pass1 is compolsury, Pass2 is optional."
	puts 
	puts "To encrypt a file:"
	puts "	\"ruby gSS.rb hide PathToFile Pass1 Pass2\""
	puts
	puts "To decrypt a file:"
	puts "	\"ruby gSS.rb reveal PathToFile Pass1 Pass2\""
	puts
	puts "To encrypt a directory (asking are you sure for each file):"
	puts "	\"ruby gSS.rb hideDir PathToDir Pass1 Pass2\""
	puts
	puts "To decrypt a directory (asking are you sure for each file):"
	puts "	\"ruby gSS.rb revealDir PathToDir Pass1 Pass2\""
	puts
	puts "To encrypt a directory (WARNING: you are asked only once for the whole dir):"
	puts "	\"ruby gSS.rb hideDirAll PathToDir Pass1 Pass2\""
	puts
	puts "To decrypt a directory (WARNING: you are asked only once for the whole dir):"
	puts "	\"ruby gSS.rb revealDirAll PathToDir Pass1 Pass2\""
	puts
	puts "--------------------------------------------------------------------------------"
	abort()
end

if ARGV[2] != nil 
	if ARGV[0] == "hide"
		hideImplement(ARGV[1], true)
	elsif ARGV[0] == "reveal"
		revealImplement(ARGV[1], true)
	elsif ARGV[0] == "hideDir"
		abort("Path \"#{ARGV[1]}\" is not directory!") if not File.directory?(ARGV[1])
		Dir.glob("#{ARGV[1]}/*.*") do |target|
			hideImplement(target, true)
		end
	elsif ARGV[0] == "revealDir"
		abort("Path \"#{ARGV[1]}\" is not directory!") if not File.directory?(ARGV[1])
		Dir.glob("#{ARGV[1]}/*.*") do |target|
			revealImplement(target, true)
		end
	elsif ARGV[0] == "hideDirAll"
		abort("Path \"#{ARGV[1]}\" is not directory!") if not File.directory?(ARGV[1])
		puts "Are you sure you want to encrypt whole dir \"#{ARGV[1]}\" with passwords:" 
		puts "\"#{ARGV[2]}\" \"#{ARGV[3]}\"? (yes/no)"
		command = STDIN.gets.chomp
		if command == "yes"
			Dir.glob("#{ARGV[1]}/*.*") do |target|
				hideImplement(target, false)
			end
		end
	elsif ARGV[0] == "revealDirAll"
		abort("Path \"#{ARGV[1]}\" is not directory!") if not File.directory?(ARGV[1])
		puts "Are you sure you want to decrypt whole dir \"#{ARGV[1]}\" with passwords:" 
		puts "\"#{ARGV[2]}\" \"#{ARGV[3]}\"? (yes/no)"
		command = STDIN.gets.chomp
		if command == "yes"
			Dir.glob("#{ARGV[1]}/*.*") do |target|
				revealImplement(target, false)
			end
		end
	else
		puts "Invalid command! For help type: \"ruby gSS.rb\""
		puts "---------------------------------------------"
	end
else
	puts "Pass1 is compulsory! For help type: \"ruby gSS.rb\""
	puts "-------------------------------------------------"
end
