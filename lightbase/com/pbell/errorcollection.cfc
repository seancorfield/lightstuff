<cfcomponent extends="lightbase.com.pbell.base.baseobject" hint="I encapsulate errors within a business object" output="false" ><cfscript>

// ***************** CONSTRUCTOR *****************

function init( DataTypeFacade ) {
	super.init();
	variables.DataTypeFacade = arguments.DataTypeFacade;
	variables.errors = structNew();
	THIS.setValidated( false );
	return THIS;
}

// ***************** PUBLIC METHODS *****************

function _setMetadata ( Metadata ) {
	variables.Metadata = arguments.Metadata;
}

function _setValidator ( Validator ) {
	variables.Validator = arguments.Validator;
}

function isValidObject ( PropertyNameList , Object , ValidationContextList ) {
	var i = 0;
	clearErrors();
	THIS.setValidated( true );
	validatePropertiesByDataType( arguments.PropertyNameList , arguments.Object );
	for ( i = 1 ; i lte listlen( arguments.ValidationContextList ) ; i++ ) { 
		ValidationContext = ListGetAt( arguments.ValidationContextList , i );
		validateContext( arguments.Object , ValidationContext );
	}
	if( structCount( variables.errors )  ) {
		return false;
	} 
	return true;
}

function getErrors( PropertyName ) {
	if ( NOT THIS.get( "Validated#arguments.PropertyName#" ) ) {
		return "This property (#arguments.PropertyName#) has not been validated. Please call isValid() first";
	};
	if ( structKeyExists( variables.errors , arguments.PropertyName ) ) {
		return variables.errors[ arguments.PropertyName ];
	}
	return "";
}

function errorDisplay( PropertyNameList ) {
	var ErrorDisplay = "";
	var ErrorList = "";
	var ErrorKey = "";
	var PropertyNameList = arguments.PropertyNameList;
	var PropertyName = "";
	var i = 0;
	var j = 0;
	if ( NOT THIS.getValidated() ) {
		return "This object has not been validated. Please call isValid() first";
	};
	if ( structCount( variables.errors ) ) {
		ErrorDisplay &= "<ul class='error-list'>"
		for ( i = 1 ; i lte listlen( PropertyNameList ) ; i++ ) { 
			PropertyName = ListGetAt( PropertyNameList , i );
			ErrorList = getErrors( PropertyName );
			for ( j = 1 ; j lte listlen( ErrorList ) ; j++ ) { 
				ErrorKey = ListGetAt( ErrorList , j );
				ErrorDisplay &= "<li>#PropertyName#: #ErrorKey#</li>";
			};
		};
		ErrorDisplay &= "</ul>"
	};
	return ErrorDisplay;
}


// ***************** PRIVATE METHODS *****************

function addError ( PropertyName , ErrorKey ) {
	if( structKeyExists( variables.errors , arguments.PropertyName ) ) {
		variables.errors[ arguments.PropertyName ] &= "," & arguments.ErrorKey;
	}
	else {
		variables.errors[ arguments.PropertyName ] = arguments.ErrorKey;
	}
}

function clearErrors() {
	variables.instance = structNew();
	variables.errors = structNew();
}

function validateContext( Object , ValidationContext ) {
	var ValidationContextStruct = variables.Metadata.getValidationContext( arguments.ValidationContext );
	var RequiredPropertyNameList = ValidationContextStruct.RequiredPropertyNameList;
	var ValidationRuleList = ValidationContextStruct.ValidationRuleList;
	var ValidationRuleName = "";
	var i = 0;
	validateRequiredFields( arguments.Object , RequiredPropertyNameList);
	for ( i = 1 ; i lte listlen( ValidationRuleList ) ; i++ ) { 
		ValidationRuleName = ListGetAt( ValidationRuleList , i ); 
		validateRule( ValidationRuleName , Object );
	}	
}

function validateRule( ValidationRuleName , Object ) {
	var ValidationRule = variables.Metadata.getValidationRule( arguments.ValidationRuleName );
	var PropertyName = ValidationRule.PropertyName;
	var ErrorKey = "";
	ValidationRule.Object = arguments.Object;
	ErrorKey = evaluate( "variables.Validator.#ValidationRule.tagName#( argumentCollection=ValidationRule )" );
	if ( len( ErrorKey ) ) {
		addError( PropertyName , ErrorKey );
	}
}

function validateRequiredFields( Object , RequiredPropertyNameList ) {
	var i = 0;
	var PropertyName = "";
	for ( i = 1 ; i lte listlen( arguments.RequiredPropertyNameList ) ; i++ ) { 
		PropertyName = ListGetAt( arguments.RequiredPropertyNameList , i );
		if ( NOT Len( arguments.Object.get( PropertyName ) ) ) {
			addError( PropertyName , "Required" );
		};
	};
}

function validatePropertiesByDataType( PropertyNameList , Object ) {
	var PropertyName = "";
	var DataType = "";
	var DataTypeProperties = "";
	var ErrorKey = "";
	var key = "";
	var i = 0;
	for ( i = 1 ; i lte listlen( arguments.PropertyNameList ) ; i++ ) { 
		PropertyName = ListGetAt( arguments.PropertyNameList , i );
		DataType = variables.Metadata.getProperty( PropertyName ).DataType;
		DataTypeProperties = variables.Metadata.getProperty( PropertyName ).DataTypeProperties;
		ErrorKey = variables.DataTypeFacade.validateProperty( PropertyName , arguments.Object.get( PropertyName ) , DataType , DataTypeProperties );
		if ( len( ErrorKey ) ) {
			addError( PropertyName , ErrorKey );
		};
		THIS.set( "Validated#PropertyName#" , true );
	};
}

</cfscript></cfcomponent>