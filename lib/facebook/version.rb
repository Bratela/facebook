module Facebook
	class Version
		MAJOR = 0 unless defined? Facebook::Version::MAJOR
		MINOR = 3 unless defined? Facebook::Version::MINOR
		PATCH = 0 unless defined? Facebook::Version::PATCH
		PRE = nil unless defined? Facebook::Version::PRE

		class << self

			def to_s
				[MAJOR, MINOR, PATCH, PRE].compact.join('.')
			end

		end

	end
end

