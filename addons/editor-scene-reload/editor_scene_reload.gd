@tool
extends EditorPlugin

var reload_button: Button

func _enter_tree() -> void:
	# Create the button
	reload_button = Button.new()
	reload_button.text = "Reload Scene"
	reload_button.tooltip_text = "Reload the currently edited scene"
	
	# Add some basic styling to match the editor
	reload_button.flat = true
	
	# Connect the pressed signal
	reload_button.pressed.connect(_on_reload_pressed)
	
	# Add the button to the top-right toolbar (CONTAINER_TOOLBAR)
	# This places it near the rendering/perspective menus
	add_control_to_container(CONTAINER_TOOLBAR, reload_button)

func _exit_tree() -> void:
	# Clean up the button when the plugin is disabled
	if reload_button:
		remove_control_from_container(CONTAINER_TOOLBAR, reload_button)
		reload_button.queue_free()

func _on_reload_pressed() -> void:
	var editor_interface = get_editor_interface()
	var scene_root = editor_interface.get_edited_scene_root()
	if not scene_root:
		print("Reload Scene: No active scene found.")
		return
		
	var current_scene_path = get_editor_interface().get_edited_scene_root().scene_file_path
	
	if current_scene_path == "":
		print("Reload Scene: Scene must be saved to disk before reloading.")
		return
		
	# 1. Save the current state so you don't lose progress
	editor_interface.save_scene()
	
	# 2. Close the scene tab
	# We use the path to tell the editor which specific scene to shut down
	editor_interface.close_scene()
	
	# 3. Re-open the scene
	# This forces the editor to reload the .tscn file from the drive
	editor_interface.open_scene_from_path(current_scene_path)
	
	print("Hard reloaded scene: ", current_scene_path)
