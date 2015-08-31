<cfcomponent extends="lightbase.com.pbell.base.baseobject" output="false" hint="I encapsulate access to the properties specific to a given request/event"><cfscript>

// ***************** CONSTRUCTOR *****************

function init( ApplicationMetaData ) {
	variables.instance = structNew();
	variables.ApplicationMetaData = arguments.ApplicationMetaData;
	return THIS;
}

function setup() {
	// hint: I'm called after loading form and URL scopes to finish setting up the event bean
	// Set the controller name and method based on the action variable in the URL/form scope
	if ( structKeyExists( variables.instance , "action" ) ) {
		variables.instance.ControllerName = listGetAt( variables.instance.action , 1 , "." );
		if ( listlen( variables.instance.action , "." ) EQ 2 ) {
			variables.instance.ControllerMethod = listGetAt( variables.instance.action , 2 , "." );
		}
	}
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function defaultValue( PropertyName ) {
	return variables.ApplicationMetaData.getinputPropertyDefaultValue( PropertyName );
}

function load( structtoLoad ) {
	structAppend( variables.instance , arguments.structtoLoad );
	return THIS;
}

function get( PropertyName ) {
	if ( structKeyExists( variables.instance , arguments.PropertyName ) ) {
		return variables.instance[ arguments.PropertyName ];
	}
	else {
		return defaultValue( PropertyName );
	};
}

function getViewPath() {
	return "/" & application.applicationname & "/views/" & Replace( getView() , "." , "/" );
}


// ***************** PRIVATE METHODS *****************

function getAction() {
	return this.getControllerName() & "." & this.getControllerMethod();
}

function getView() {
	if ( structKeyExists( variables.instance , "View" ) ) {
		return variables.instance.View;
	}
	return getAction();
}

</cfscript></cfcomponent>