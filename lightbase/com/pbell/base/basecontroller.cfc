<cfcomponent extends="lightbase.com.pbell.meta.basemetaclass" output="false"><cfscript>
	
// ***************** CONSTRUCTOR *****************
function init ( MetadataObject ) {
	super.init( MetadataObject );
	variables.ClassType = "Controller";
	variables.newLine = chr(13);
	return THIS;
}


// ***************** PUBLIC METHODS *****************

function _delete( event ) {
	var ProcessedArguments = processArguments( arguments , arguments.event );
	var ObjectService = beanFactory.getBean("#ProcessedArguments.businessObject#Service");
	var Object = "";
	if (not structKeyExists( ProcessedArguments , "PropertyName" ) ) {ProcessedArguments.PropertyName = "Id";};
	Object = evaluate("ObjectService.getByProperty( argumentCollection=ProcessedArguments)");
	if ( arguments.event.getdeleteConfirmed() EQ "1" ) {
		Object.delete();
		saveMessage( ProcessedArguments.successMessage );
		location( ProcessedArguments.successlocation );
	};
	setView( ProcessedArguments , arguments.event );
	arguments.event.setViewData( Object );
}

function _detail( event ) {
	var ProcessedArguments = processArguments( arguments , arguments.event );
	var ObjectService = beanFactory.getBean("#ProcessedArguments.businessObject#Service");
	setView( ProcessedArguments , arguments.event );
	arguments.event.setViewData( evaluate("ObjectService.#ProcessedArguments.Method#( argumentCollection=ProcessedArguments)") );
}

function _display( event ) {
	var ProcessedArguments = processArguments( arguments , arguments.event );
	setView( ProcessedArguments , arguments.event );
	if ( structKeyExists( ProcessedArguments , "data" ) ) {
		arguments.event.setViewData( ProcessedArguments.Data );
	}
}

function _list( event ) {
	var ProcessedArguments = processArguments( arguments , arguments.event );
	var ObjectService = beanFactory.getBean("#ProcessedArguments.businessObject#Service");
	setView( ProcessedArguments , arguments.event );
	arguments.event.setViewData( evaluate("ObjectService.#ProcessedArguments.Method#( argumentCollection=ProcessedArguments )") );
}

function _objectForm( event ) {
	var ProcessedArguments = processArguments( arguments , arguments.event );
	var ObjectService = beanFactory.getBean("#ProcessedArguments.businessObject#Service");
	var Object = "";
	Object = evaluate("ObjectService._getByProperty( argumentCollection=ProcessedArguments )");
	Object._setPropertyList( ProcessedArguments.PropertyList )
	if ( arguments.event.getFormReturning() ) {
		Object._setPropertyList( ProcessedArguments.PropertyList );
		Object.loadFromEvent( arguments.Event );
		if ( Object.isValidObject( ProcessedArguments.ValidationContextList ) ) {
			Object.save();
			saveMessage( ProcessedArguments.successMessage );
			location( ProcessedArguments.successlocation );
		};
	};
	Object._setFormTitle( ProcessedArguments.title );
	setView( ProcessedArguments , arguments.event );
	setFormResource( Object , ProcessedArguments , arguments.event );
	arguments.event.setViewData( Object );
}


// ***************** PRIVATE METHODS *****************

function processArguments( ArgumentsToProcess , event ) {
	var key = "";
	var ProcessedArguments = structNew();
	var Property = "";
	for ( key in arguments.ArgumentsToProcess ) {
		if ( isSimpleValue( ArgumentsToProcess[ key ] ) and Find( "%" , ArgumentsToProcess[ key ] )) {
			if( left( ArgumentsToProcess[ key ] , 1 ) EQ "%" AND right( ArgumentsToProcess[ key ] , 1 ) EQ "%") {
				// Just a simple, single variable like %object%
				Property = Replace( ArgumentsToProcess[ key ] , "%" , "" , "all" )
				ProcessedArguments[ key ] = arguments.event.get( Property );
			}
			else {
				// Complex string like index.cfm?action=%action%&object=%user%
				ProcessedArguments[ key ] = evaluateString( ArgumentsToProcess[ key ], arguments.event );
			};
		}
		else {
			ProcessedArguments[ key ] = ArgumentsToProcess[ key ];
		};
	};
	return ProcessedArguments;
}

function saveMessage( Message ) {
	session.message = arguments.Message;
}

function setFormResource( Object , ProcessedArguments , event ) {
	var FormHeader = "<form action='index.cfm' method='post' enctype='multipart/form-data'>" & variables.newline;
	var FormFooter = "</form>";
	var FormSubmit = "<input type='submit' value='submit' />"
	FormHeader &= "<input type='hidden' name='action' value='#arguments.event.getAction()#' />" & variables.newline;
	FormHeader &= "<input type='hidden' name='FormReturning' value='1' />" & variables.newline;
	FormHeader &= "<input type='hidden' name='#arguments.ProcessedArguments.PropertyName#' value='#arguments.ProcessedArguments.PropertyValue#' />" & variables.newline;
	arguments.event.setFormHeader( FormHeader );
	arguments.event.setFormFooter( FormFooter );
	arguments.event.setFormSubmit( FormSubmit );
}

function setView( ProcessedArguments , event ) {
	if ( structKeyExists( arguments.ProcessedArguments , "view" ) ) {
		arguments.event.setView( arguments.ProcessedArguments.View );
	}
}

function setMethodDefaults( MethodProperties ) {
	var MethodType = MethodProperties.TagName;
	var MethodProperties = arguments.MethodProperties;
	switch( MethodType ) {
		
		case "objectform" : {
			MethodProperties = setDefault( MethodProperties , "PropertyName" , "Id" );
			MethodProperties = setDefault( MethodProperties , "PropertyValue" , 0 );
			MethodProperties = setDefault( MethodProperties , "validationContextList" , "" );
		}
	}
	return MethodProperties;
}

</cfscript>
<cffunction name="location" access="private" returntype="void" output="false">
	<cfargument name="Location" type="string" required="true">
	<cflocation url="#arguments.location#" addtoken="true">
</cffunction>

<cffunction name="evaluateString" access="public" returntype="string" output="false">
    <cfargument name="targetString" type="string" required="true" />
    <cfargument name="event" type="any" required="true" />
    <cfset var local = {} />
    <cfset local.pattern = createObject( "java", "java.util.regex.Pattern" ).compile( javaCast( "string", "%(\w+)%" ) ) />
    <cfset local.matcher = local.pattern.matcher( javaCast( "string", arguments.targetString ) ) />
    <!--- The new string (buffer). --->
    <cfset local.newBuffer = createObject( "java", "java.lang.StringBuffer" ).init() />
    <cfloop condition="local.matcher.find()">
        <cfset local.matcher.appendReplacement(
            local.newBuffer,
            reReplace(
                arguments.event.get( local.matcher.group( javaCast( "int", 1 ) ) ),
                "([$\\])",
                "\\$1",
                "all"                
                )
            ) />
    </cfloop>
    <cfset local.matcher.appendTail( local.newBuffer ) />
    <cfreturn local.newBuffer.toString() />
</cffunction>
</cfcomponent>