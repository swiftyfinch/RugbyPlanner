class String
	def colorize(color_code)
		"\e[38;5;#{color_code}m#{self}\e[0m"
	end
end

BUMP_TYPE = ARGV[0]
unless /^(major|minor|patch)$/.match?(BUMP_TYPE)
	abort("Please, pass one of these major/minor/patch bump type.".colorize(9))
end

VERSION = %x[grep -Eo '[0-9]+(\.[0-9]+)?(\.[0-9]+)?' RugbyPlanner/Project.xcconfig].chomp
VERSION_PARTS = VERSION.split(".").map(&:to_i)

if BUMP_TYPE == "major"
	VERSION_PARTS[0] += 1
	VERSION_PARTS[1] = 0
	VERSION_PARTS[2] = 0
elsif BUMP_TYPE == "minor"
	VERSION_PARTS[1] += 1
	VERSION_PARTS[2] = 0
elsif BUMP_TYPE == "patch"
	VERSION_PARTS[2] += 1
end
NEW_VERSION = VERSION_PARTS.join(".")

# Update version in xcconfig
%x[sed -i '' 's/#{VERSION}/#{NEW_VERSION}/g' RugbyPlanner/Project.xcconfig]
# Update version for Homebrew
%x[sed -i '' 's/#{VERSION}/#{NEW_VERSION}/g' Casks/rugby-planner.rb]

puts BUMP_TYPE.capitalize + ": " + VERSION + " → " + NEW_VERSION
