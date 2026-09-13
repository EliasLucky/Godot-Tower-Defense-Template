extends Node

# Using Poing Studios AdMob Plugin
# This is the official Google AdMob Interstitial Test ID
const INTERSTITIAL_AD_ID = "ca-app-pub-3940256099942544/1033173712"

@onready var ad_timer : Time = $ad_timer
var interstitial_ad : InterstitialAd

func _ready() -> void:
	ad_timer.timeout.connect(_on_ad_timer_timeout)
	load_interstitial_ad()

func load_intestitial_ad() -> void:
	# Request a new ad from Google in the background
	InterstitialAdLoader.new().load(INTERSTITIAL_AD_ID, AdRequest.new(), _on_ad_loaded)

func _on_ad_loaded(ad : InterstitialAd, error: LoadAdError) -> void:
	if error:
		print("Ad failed to background load: ", error.get_message())
		get_tree().create_timer(15.0).timeout.connect(load_interstitial_ad)
	
	interstitial_ad = ad
	intesrtitial_ad.ad_dismissed_full_screen_content.connect(_on_ad_closed)

func _on_ad_timer_timeout() -> void:
	if interstitial_ad:
		get_tree().paused = true

		interstitial_ad.show()
	else:
		# ad wasn't fully loaded yet

func _on_ad_closed() -> void:
	print("Player closed the ad. Resuming game.")
	get_tree().paused = false

	interstitial_ad = null
	_load_interstitial_ad()

