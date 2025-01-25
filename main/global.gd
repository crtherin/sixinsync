#@tool
#class_name Global
extends Node

#region Signals
@warning_ignore("unused_signal")
signal item_dropped_in_cup(item: Item)

@warning_ignore("unused_signal")
signal cup_dropped_on_customer

@warning_ignore("unused_signal")
signal cup_dropped_on_trash

@warning_ignore("unused_signal")
signal warning_message_requested(text: String)
#endregion

#region Enums
#endregion

#region Constants
#endregion

#region Export Variables
#endregion

#region Public Variables
var is_paused: bool
var item_is_dragging: bool
var cup_is_dragging: bool
#endregion

#region Private Variables
#endregion

#region OnReady Variables
#endregion

#region Virtual Methods
#endregion

#region Public Methods
#endregion

#region Private Methods
#endregion

#region Static Methods
#endregion

#region Signal Callbacks
#endregion

#region SubClasses
#endregion

#region Setter Methods
#endregion

#region Getter Methods
#endregion
