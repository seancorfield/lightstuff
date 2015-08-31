<cfcomponent extends="lightbase.com.pbell.base.basedatatype" output="false"><cfscript>

// ***************** PUBLIC METHODS *****************

function field( PropertyName , PropertyValue , DataTypeProperties ) {
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	return "<input type='text' name='#PropertyName#' value='#PropertyValue#' size='#Properties.Size#' maxlength='#Properties.maxlength#'/>";
}

function validateProperty( PropertyName , PropertyValue , DataTypeProperties ) {
	var Properties = ProcessDataTypeProperties( arguments.DataTypeProperties );
	var ErrorMessage = "";
	if ( len( PropertyValue ) GT Properties.maxLength ) {
		ErrorMessage = addError( ErrorMessage , "#PropertyName# is too long (#len(PropertyValue)# characters). The maximum length is #properties.maxLength#." );
	};
	return ErrorMessage;
}


// ***************** PRIVATE METHODS *****************
function addError( CurrentErrorMessage , NewErrorMessage ) {
	return listAppend( arguments.CurrentErrorMessage , arguments.NewErrorMessage , "|" );
}

</cfscript></cfcomponent>