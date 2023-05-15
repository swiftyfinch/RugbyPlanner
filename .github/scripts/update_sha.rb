PATH_TO_APP = ARGV[0]

# Calculate sha
SHA = %x[shasum -a 256 '#{PATH_TO_APP}'].split(' ').first
puts SHA

# Replace sha
file_path = 'Casks/RugbyPlanner.rb'
text = File.read(file_path)
updated_text = text.gsub(/sha256 '.*'/, "sha256 '#{SHA}'")
File.write(file_path, updated_text)

# Add commit & tag
VERSION = %x[grep -Eom1 '[0-9]+(\.[0-9]+)?(\.[0-9]+)?' Casks/RugbyPlanner.rb].chomp
# Add bump commit
%x[git commit -i RugbyPlanner/Project.xcconfig Casks/RugbyPlanner.rb -m "Bump version #{VERSION}"]
# Add new git tag
%x[git tag #{VERSION}]
