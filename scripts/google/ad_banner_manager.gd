extends Node

const BANNER_AD_UNIT_ID = "ca-app-pub-3940256099942544/6300978111"

var banner_ad : AdView

func _ready() -> void:
	banner_ad = AdView.new(BANNER_AD_UNIT_ID, AdSize.BANNER, AdPosition.BOTTOM)

	banner_ad.ad_loaded.connect(_on_banner_loaded)
	banner_ad.ad_failed_to_load.connect(_on_banner_failed)

	# Request the ad from Google
	banner_ad.load_ad(AdRequest.new())

func _on_banner_loaded() -> void:
	banner_ad.show()

func _on_banner_failed(error_code : int, message : String) -> void:
	print("Ad failed to load. Code: ", error_code, " Message: ", message)
