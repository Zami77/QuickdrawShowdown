extends Node2D

onready var enemyIdleTexture: Texture = load("res://assets/showdown-samurai-enemy.png")
onready var enemyDrawnTexture: Texture = load("res://assets/showdown-samurai-enemy-sword-up.png")
onready var enemyKOTexture: Texture = load("res://assets/showdown-samurai-enemy-KO.png")

func _on_Player_enemy_sprite_update(enemy_sprite: String):
	match enemy_sprite:
		"idle":
			$Sprite.texture = enemyIdleTexture
		"sword":
			$Sprite.texture = enemyDrawnTexture
		"ko":
			$Sprite.texture = enemyKOTexture
