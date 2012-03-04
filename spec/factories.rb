Factory.define :user do |user|
	user.name "Tushar Garg"
	user.email "tgarg@uci.edu"
	user.password "foobar"
	user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
	"person-#{n}@example.com"
end