extends Node

const NOADS_FOREVER_PRODUCT_ID = "unlock"

var payment_provider

var gamepass_noads_forever : bool = false

signal billing_initialized
signal purchase_checked

func _eady() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment_provider = Engine.get_singleton("GodotGooglePlayBilling");

		payment_provider.connected.connect(_on_connected)
		payment_provider.disconnected.connect(_on_disconnected)
		payment_provider.query_purchases_response.connect(_on_query_purchases_response)
		payment_provider.purchases_updated.connect(_on_purchases_updated)

		# Start connection to Google Play
		payment_provider.startConnection()
	else:
		print("Google Play Billing plugin is not vailable")

func _on_connected() -> void:
	print("Successfully connected to Google Play Billing.")
	billing_initialized.emit()

	check_owned_purchases()

func _on_disconnected() -> void:
	print("Disconnected from Google Play Billing.")

func check_owned_purchases() -> void:
	if payment_provider:
		# inapp - standard products; subs - subscription
		payment_provider.queryPurchases("inapp")

func _on_query_purchases_response(query_result : Dictionary) -> void:
	if query_result.status == 0:
		var purchases = query_result.purchases
		#var found_lifetime : bool = false

		for purchase in purchases:
			if NOADS_FOREVER_PRODUCT_ID in purchase.products:
				if not purchase.is_acknowledged:
					payment_provider.acknowledgePurchase(purchase.purchase_token)
				gamepass_noads_forever = true
			

		_apply_lifetime_perks()
	else:
		print("Failed to query purchases. Error code: ", query_result.status)
	
	purchase_checked.emit()

func _apply_lifetime_perks() -> void:
	if gamepass_noads_forever:
		print("Player owns No ADs Forever!")
	
	if gamepass_premium_pro:
		print("Player owns PREMIUM PRO")

func purchase_lifetime() -> void:
	if not payment_provider:
		print("Cannot purchase: Payment provider unavailable.")
		return

	if is_lifetime_owned:
		print("Player already owns this product!")
		return
	
	var response = payment_provider.launchBillingFlow(LIFETIME_PRODUCT_ID, "inapp")
	if response.status != 0:
		print("Failed to launch billing flow. Error: ", response.status)

func _on_purchases_updated(query_result : Dictionary) -> void:
	if query_result.status == 0:
		check_owned_purchases()
