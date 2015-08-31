<cfcomponent name="basecontrollermetadata" extends="basemetadata" output="false"><cfscript>

// ***************** CONSTRUCTOR *****************
function init ( ControllerName ) {
	var ControllerXMLFilePath = expandPath("../../samples/controllergen/metadatadirectory/controllers/#ControllerName#.xml");
	super.init( "controller" , "methods" , ControllerXmlFilePath )
	return THIS;
}

</cfscript></cfcomponent>