#@tool
class_name CustomerData
extends Resource

#region Signals
#endregion

#region Enums
enum Type {
	GENERIC_MAN, GENERIC_WOMAN,
	SUN_TZU, NAPOLEON, HITLER, HERCULES, APHRODITE, STALIN, GENGHIS_KHAN, MUSSOLINI, LEO_DAVINCI, MAO_TSE_TUNG, ALFRED_NOBEL,
	}
#endregion

#region Constants
#endregion

#region Export Variables
@export var type: Type = Type.GENERIC_MAN
@export var texture: Texture2D
@export var name: String
#endregion

#region Public Variables
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
