class Restaurant < ActiveRecord::Base
	has_many :reviews, dependent: :destroy
	validates :name, length: { 	minimum: 3, 
								message: ": please create a longer name"
								}, uniqueness: true
	has_attached_file :image, :styles => { 	:medium => "300x300>", 
											:thumb => "100x100>" , 
											:default_url => "/images/:style/missing.png"
											# :storage => :s3, 
											# :s3_credentials => Proc.new {|a| a.instance.s3_credentials } 
										}
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	def average_rating
		return 'N/A' if reviews.none?
		reviews.average(:rating)
	end 

	# def s3_credentials
	# 	{:bucket => "picnicwise", 
	# 	:access_key_id => Rails.application.secrets.s3_access_key, 
	# 	:secret_access_key => Rails.application.secrets.s3_secret_key}
	# end

end
