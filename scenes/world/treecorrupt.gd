extends Sprite2D

var animatetree = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_corruption(percentcor):
	#$clight.energy = percentcor
	#percentcor = 1 - percentcor
	$Corrode.material.set("shader_parameter/cutoff_two", percentcor)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
var corroded = false
var curcor = 2
func _process(delta):
	if not corroded and animatetree:
		#This animation playing on hundreds of trees dips the framerate massively (-30 fps)
		var tween1 = create_tween()
		curcor = curcor - 0.01
		#damp /= 1.01
		tween1.tween_property($Corrode.material, "shader_parameter/cutoff_two", curcor, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT) 
		if curcor <= -1:
			corroded = true
		#So I will probably just make it not animate generally, and if it does animate it should
		#only be the trees in the direct vision of the player
		
	
