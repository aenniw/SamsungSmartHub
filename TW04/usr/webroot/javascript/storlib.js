
function isAlpha( ch )
{
	var symbol = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	if(symbol.indexOf( ch ) == -1)
		return false;
	return true;
}

function isLowercaseAlpha( ch )
{
	var symbol = "abcdefghijklmnopqrstuvwxyz";
	if(symbol.indexOf( ch ) == -1)
		return false;
	return true;
}

function isUppercaseAlpha( ch )
{
	var symbol = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	if(symbol.indexOf( ch ) == -1)
		return false;
	return true;
}

function isNumeric( ch )
{
	var symbol = "0123456789";
	if(symbol.indexOf( ch ) == -1)
		return false;
	return true;
}

function isHex( ch )
{
	var symbol = "0123456789ABCDEFabcdef";
	if(symbol.indexOf( ch ) == -1)
		return false;
	return true;
}

function isHostNameSymbol( ch )
{// ***** only the '-' is allowd
	var symbol = ".-";
	if(symbol.indexOf( ch ) == -1)
		return true;
	return false;
}

function isDomainSymbol( ch )
{
	var symbol = "@&";
	if(symbol.indexOf( ch ) == -1)
		return false;
	return true;
}

function isDesc( ch )
{
	var symbol = " .-_";
	if(symbol.indexOf( ch ) == -1)
		return false;
	return true;
}






function get_cookie()
{
	var allcookies = document.cookie;
	var pos = allcookies.indexOf("LoginUser=admin");
	if (pos == -1)
		location = "/index.html";
}


function gotoUrl(target)
{
	parent.mainFrame.location = target;
}


function BumpUp(nonMember)
{
	for(var i = 0; i < nonMember.options.length; i++)
	{
		if(nonMember.options[i].value == "")
		{
			for(var j = i; j < nonMember.options.length - 1; j++)
			{
				nonMember.options[j].value = nonMember.options[j + 1].value;
				nonMember.options[j].text = nonMember.options[j + 1].text;
			}
			var ln = i;
			break;
		}
	}

	if(ln < nonMember.options.length - 1)
	{
		nonMember.options.length -= 1;
		BumpUp(nonMember);
	}
}


function AddItem(member, nonMember, doc)
{
	if ( nonMember.options[nonMember.options.length - 1].selected && 
		nonMember.options[nonMember.options.length - 1].text == "===== END LIST =====" )
	{
		return;
	}

	//remove "===== END LIST =====" first
	member.options[member.options.length - 1].selected = false;
	member.options[member.options.length - 1].value = "";
	member.options[member.options.length - 1].text = "";
	member.options.length--;

	for(var i=0; i<nonMember.options.length; i++)
	{
		if( nonMember.options[i].selected && nonMember.options[i] != "")
		{
			var value = nonMember.options[i].value;
			var text = nonMember.options[i].text;

			// add element to the document.form.member
			var newOption = doc.createElement("OPTION");
			newOption.value = value;
			newOption.text = text;
			member.options[member.options.length++] = newOption;

			// clear the document.form.nonMember
			nonMember.options[i].selected = false;
			nonMember.options[i].value = "";
			nonMember.options[i].text = "";
		}
	}
	BumpUp(nonMember);

	//add "===== END LIST =====" final
	var newOption = doc.createElement("OPTION");
	newOption.value = "===== END LIST =====";
	newOption.text = "===== END LIST =====";
	member.options[member.options.length++] = newOption;
}


function share_AddItem(doc, access_right)
{
	allowed = doc.form.allowed
	noaccess = doc.form.noaccess

	if ( noaccess.options[noaccess.options.length - 1].selected && 
		noaccess.options[noaccess.options.length - 1].text == "===== END LIST =====" )
	{
		return;
	}

	//remove "===== END LIST =====" first
	allowed.options[allowed.options.length - 1].selected = false;
	allowed.options[allowed.options.length - 1].value = "";
	allowed.options[allowed.options.length - 1].text = "";
	allowed.options.length--;

	for(var i=0; i<noaccess.options.length; i++)
	{
		if( noaccess.options[i].selected && noaccess.options[i] != "")
		{
			var value = noaccess.options[i].value + " (" + access_right + ")";
			var text = noaccess.options[i].text + " (" + access_right + ")";

			// add element to the document.form.member
			var newOption = doc.createElement("OPTION");
			newOption.value = value;
			newOption.text = text;
			allowed.options[allowed.options.length++] = newOption;

			// clear the document.form.nonMember
			noaccess.options[i].selected = false;
			noaccess.options[i].value = "";
			noaccess.options[i].text = "";
		}
	}
	BumpUp(noaccess);

	//add "===== END LIST =====" final
	var newOption = doc.createElement("OPTION");
	newOption.value = "===== END LIST =====";
	newOption.text = "===== END LIST =====";
	allowed.options[allowed.options.length++] = newOption;
}


function share_RemoveItem(doc)
{
	allowed = doc.form.allowed
	noaccess = doc.form.noaccess

	if ( allowed.options[allowed.options.length - 1].selected && 
		allowed.options[allowed.options.length - 1].text == "===== END LIST =====" )
	{
		return;
	}

	//remove "===== END LIST =====" first
	noaccess.options[noaccess.options.length - 1].selected = false;
	noaccess.options[noaccess.options.length - 1].value = "";
	noaccess.options[noaccess.options.length - 1].text = "";
	noaccess.options.length--;

	for(var i=0; i<allowed.options.length; i++)
	{
		if( allowed.options[i].selected && allowed.options[i] != "")
		{
			var value = allowed.options[i].value;
			var text = allowed.options[i].text;

			// remove access right
			var p = value.indexOf(' ');
			value = value.substr(0, p);
			p = text.indexOf(' ');
			text = text.substr(0, p);

			// add element to the document.form.member
			var newOption = doc.createElement("OPTION");
			newOption.value = value;
			newOption.text = text;
			noaccess.options[noaccess.options.length++] = newOption;

			// clear the document.form.allowed
			allowed.options[i].selected = false;
			allowed.options[i].value = "";
			allowed.options[i].text = "";
		}
	}
	BumpUp(allowed);

	//add "===== END LIST =====" final
	var newOption = doc.createElement("OPTION");
	newOption.value = "===== END LIST =====";
	newOption.text = "===== END LIST =====";
	noaccess.options[noaccess.options.length++] = newOption;
}


function NFS_AddItem(doc, msg_ip_error, msg_subnet_error, msg_blank, msg_check_invalid, msg_greater, msg_less)
{
	var msg = "";
	allowed = doc.form.allowed

	if (doc.form.addIP[0].checked == true)
	{
		msg = storlib_checkIpValue(doc.form.ipaddr_1, doc.form.ipaddr_2, doc.form.ipaddr_3, doc.form.ipaddr_4, 0, 255, 0, 255, 0, 255, 0, 255, true, msg_ip_error, msg_blank, msg_check_invalid, msg_greater, msg_less)
		if(msg.length > 0)
		{
			alert(msg);
			return false;
		}
	}
	if (doc.form.addIP[1].checked == true)
	{
		msg = storlib_checkIpValue(doc.form.subnet_1, doc.form.subnet_2, doc.form.subnet_3, doc.form.subnet_4, 0, 255, 0, 255, 0, 255, 0, 255, true, msg_subnet_error, msg_blank, msg_check_invalid, msg_greater, msg_less)
		if(msg.length > 0)
		{
			alert(msg);
			return false;
		}
		msg = storlib_checkIpValue(doc.form.mask_1, doc.form.mask_2, doc.form.mask_3, doc.form.mask_4, 0, 255, 0, 255, 0, 255, 0, 255, true, msg_subnet_error, msg_blank, msg_check_invalid, msg_greater, msg_less)
		if(msg.length > 0)
		{
			alert(msg);
			return false;
		}
	}

	//remove "===== END LIST =====" first
	allowed.options[allowed.options.length - 1].selected = false;
	allowed.options[allowed.options.length - 1].value = "";
	allowed.options[allowed.options.length - 1].text = "";
	allowed.options.length--;

	if (doc.form.addIP[0].checked == true)
	{
		var value = doc.form.ipaddr_1.value + "." + doc.form.ipaddr_2.value + "." + doc.form.ipaddr_3.value + "." + doc.form.ipaddr_4.value;
		var text = doc.form.ipaddr_1.value + "." + doc.form.ipaddr_2.value + "." + doc.form.ipaddr_3.value + "." + doc.form.ipaddr_4.value;

		// add element to the document.form.member
		var newOption = doc.createElement("OPTION");
		newOption.value = value;
		newOption.text = text;
		allowed.options[allowed.options.length++] = newOption;

		// clear the document.ip value
		doc.form.ipaddr_1.value = "";
		doc.form.ipaddr_2.value = "";
		doc.form.ipaddr_3.value = "";
		doc.form.ipaddr_4.value = "";
	}
	if (doc.form.addIP[1].checked == true)
	{
		var value = doc.form.subnet_1.value + "." + doc.form.subnet_2.value + "." + doc.form.subnet_3.value + "." + doc.form.subnet_4.value + "-" + doc.form.mask_1.value + "." + doc.form.mask_2.value + "." + doc.form.mask_3.value + "." + doc.form.mask_4.value;
		var text = doc.form.subnet_1.value + "." + doc.form.subnet_2.value + "." + doc.form.subnet_3.value + "." + doc.form.subnet_4.value + "/" + doc.form.mask_1.value + "." + doc.form.mask_2.value + "." + doc.form.mask_3.value + "." + doc.form.mask_4.value;

		// add element to the document.form.member
		var newOption = doc.createElement("OPTION");
		newOption.value = value;
		newOption.text = text;
		allowed.options[allowed.options.length++] = newOption;

		// clear the document.ip value
		doc.form.subnet_1.value = "";
		doc.form.subnet_2.value = "";
		doc.form.subnet_3.value = "";
		doc.form.subnet_4.value = "";
		doc.form.mask_1.value = "";
		doc.form.mask_2.value = "";
		doc.form.mask_3.value = "";
		doc.form.mask_4.value = "";
	}

	//add "===== END LIST =====" final
	var newOption = doc.createElement("OPTION");
	newOption.value = "===== END LIST =====";
	newOption.text = "===== END LIST =====";
	allowed.options[allowed.options.length++] = newOption;
}


function NFS_RemoveItem(doc)
{
	allowed = doc.form.allowed

	if ( allowed.options[allowed.options.length - 1].selected && 
		allowed.options[allowed.options.length - 1].text == "===== END LIST =====" )
	{
		return;
	}

	for(var i=0; i<allowed.options.length; i++)
	{
		if( allowed.options[i].selected && allowed.options[i] != "")
		{
			// clear the document.form.allowed
			allowed.options[i].selected = false;
			allowed.options[i].value = "";
			allowed.options[i].text = "";
		}
	}
	BumpUp(allowed);
}


function multiSelectSubmitHandler(member, name)
{
	if ( member.options.length == 1
		&& member.options[0].text == "===== END LIST =====" )
	{
		name.value = escape("");
		return true;
	}

	var string = " ";
	for(var i = 0; i < member.options.length; i++)
	{
		if ( member.options[i].text != "===== END LIST =====" )
		{
			value = member.options[i].value;
			string += escape(value) + " ";
		}
	}

	// clean garbage
	if (string == " ")
	{
		string = "";
	}

	name.value = string;

	return true;
}


function share_multiSelectSubmitHandler(doc)
{
	allowed = doc.form.allowed
	allowRWUsers = doc.form.allowRWUsers
	allowROUsers = doc.form.allowROUsers
	allowRWGroups = doc.form.allowRWGroups
	allowROGroups = doc.form.allowROGroups

	if ( allowed.options.length == 1
		&& allowed.options[0].text == "===== END LIST =====" )
	{
		allowRWUsers.value = escape("");
		allowROUsers.value = escape("");
		allowRWGroups.value = escape("");
		allowROGroups.value = escape("");
		return true;
	}

	var stringRWUsers = " ";
	var stringROUsers = " ";
	var stringRWGroups = " ";
	var stringROGroups = " ";
	for(var i = 0; i < allowed.options.length; i++)
	{
		if ( allowed.options[i].text != "===== END LIST =====" )
		{
			value = allowed.options[i].value;
			if (value.indexOf('@') == -1)
			{
				if (value.indexOf('Writable') != -1)
				{
					var p = value.indexOf(' ');
					value = value.substr(0, p);
					stringRWUsers += escape(value) + " ";
				}
				if (value.indexOf('Read Only') != -1)
				{
					var p = value.indexOf(' ');
					value = value.substr(0, p);
					stringROUsers += escape(value) + " ";
				}
			}
			else if (value.indexOf('@') != -1)
			{
				if (value.indexOf('Writable') != -1)
				{
					var p = value.indexOf(' ');
					value = value.substr(1, p - 1);
					stringRWGroups += escape(value) + " ";
				}
				if (value.indexOf('Read Only') != -1)
				{
					var p = value.indexOf(' ');
					value = value.substr(1, p - 1);
					stringROGroups += escape(value) + " ";
				}
			}
		}
	}

	allowRWUsers.value = stringRWUsers;
	allowROUsers.value = stringROUsers;
	allowRWGroups.value = stringRWGroups;
	allowROGroups.value = stringROGroups;

	return true;
}


function wizard_sharePermission_multiSelectSubmitHandler(doc)
{
	allowed = doc.form.allowed
	allowRWShares = doc.form.allowRWShares
	allowROShares = doc.form.allowROShares

	if ( allowed.options.length == 1
		&& allowed.options[0].text == "===== END LIST =====" )
	{
		allowRWShares.value = escape("");
		allowROShares.value = escape("");
		return true;
	}

	var stringRWShares = " ";
	var stringROShares = " ";
	for(var i = 0; i < allowed.options.length; i++)
	{
		if ( allowed.options[i].text != "===== END LIST =====" )
		{
			value = allowed.options[i].value;
			if (value.indexOf('Writable') != -1)
			{
				var p = value.indexOf(' ');
				value = value.substr(0, p);
				stringRWShares += escape(value) + " ";
			}
			if (value.indexOf('Read Only') != -1)
			{
				var p = value.indexOf(' ');
				value = value.substr(0, p);
				stringROShares += escape(value) + " ";
			}
		}
	}

	allowRWShares.value = stringRWShares;
	allowROShares.value = stringROShares;

	return true;
}


function NFS_multiSelectSubmitHandler(doc)
{
	allowed = doc.form.allowed
	allowRWHosts = doc.form.allowRWHosts

	if ( allowed.options.length == 1
		&& allowed.options[0].text == "===== END LIST =====" )
	{
		allowRWHosts.value = escape("");
		return true;
	}

	var stringRWHosts = " ";
	for(var i = 0; i < allowed.options.length; i++)
	{
		if ( allowed.options[i].text != "===== END LIST =====" )
		{
			value = allowed.options[i].value;
			stringRWHosts += escape(value) + " ";
		}
	}

	allowRWHosts.value = stringRWHosts;

	return true;
}




function storlib_checkBlank(text_input_field, field_name, required, msg_blank)
// NOTE: required is true/false
{
	var error_msg = "";
	if (text_input_field.value.length < 1)
		if (required)
			error_msg = field_name + msg_blank;

	return error_msg;
}


function storlib_checkInt(text_input_field, field_name, 
						min_value, max_value, required, 
						msg_blank, msg_check_invalid, msg_greater, msg_less)
// NOTE: Doesn't allow negative numbers, required is true/false
{
	var str = text_input_field.value;
	var error_msg = "";

	error_msg = storlib_checkBlank(text_input_field, field_name, required, msg_blank);
	if (error_msg == "") // not blank, check contents
	{
		for (var i=0; i<str.length; i++)
		{
			if ((str.charAt(i) < '0') || (str.charAt(i) > '9'))
			{
				error_msg = field_name + msg_check_invalid;
			}
		}

		if (error_msg.length < 2) // don't parse if invalid
		{
			var int_value = parseInt(str);
			if (int_value < min_value)
				error_msg = field_name + msg_greater + (min_value - 1);
			if (int_value > max_value)
				error_msg = field_name + msg_less + (max_value + 1);
		}
	}

	return error_msg ;
}


function storlib_checkIpValue(ip1, ip2, ip3, ip4, 
					min1, max1, min2, max2, 
					min3, max3, min4, max4, 
					flag, msg, 
					msg_blank, msg_check_invalid, msg_greater, msg_less)
{
	var error_msg = "";

	error_msg = storlib_checkInt(ip1, msg, min1, max1, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;
	error_msg = storlib_checkInt(ip2, msg, min2, max2, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;
	error_msg = storlib_checkInt(ip3, msg, min3, max3, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;
	error_msg = storlib_checkInt(ip4, msg, min4, max4, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;

	return error_msg;
}




//var msg_blank = "%s {TAG_msg_blank}\n";
//var msg_check_invalid = "%s contains an invalid number.";
//var msg_greater = "%s must be greater than %s";
//var msg_less = "%s must be less than %s";
/*
function checkBlank(fieldObj, fname, msg_blank)
{
	var msg = "";
	if (fieldObj.value.length < 1)
		msg = addstr(msg_blank, fname);

	return msg;
}

function checkInt(text_input_field, field_name, min_value, max_value, required, msg_blank, msg_check_invalid, msg_greater, msg_less)
// NOTE: Doesn't allow negative numbers, required is true/false
{
	var str = text_input_field.value;
	var error_msg = "";

	if (text_input_field.value.length == 0) // blank
	{
alert("int blank");
		if (required)
		{
alert("int required");
alert(msg_blank);
alert(field_name);
			error_msg = addstr(msg_blank, field_name);
		}
	}
	else // not blank, check contents
	{
		for (var i=0; i<str.length; i++)
		{
			if ((str.charAt(i) < '0') || (str.charAt(i) > '9'))
			{
alert("not int "+str.charAt(i));
				error_msg = addstr(msg_check_invalid, field_name);
			}
		}
		if (error_msg.length < 2) // don't parse if invalid
		{
			var int_value = parseInt(str);
			if (int_value < min_value)
				error_msg = addstr(msg_greater, field_name, (min_value - 1));
			if (int_value > max_value)
				error_msg = addstr(msg_less, field_name, (max_value + 1));
		}
	}
	if (error_msg.length > 1)
		error_msg = error_msg + "\n";

	return(error_msg);
}

function checkIpValue(ip1, ip2, ip3, ip4, 
					min1, max1, min2, max2, 
					min3, max3, min4, max4, 
					flag, msg, 
					msg_blank, msg_check_invalid, msg_greater, msg_less)
{
	var error_msg = "";

alert("IP 1");
	error_msg=checkInt(ip1, msg, min1, max1, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;
alert("IP 2");
	error_msg=checkInt(ip2, msg, min2, max2, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;
alert("IP 3");
	error_msg=checkInt(ip3, msg, min3, max3, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;
alert("IP 4");
	error_msg=checkInt(ip4, msg, min4, max4, flag, msg_blank, msg_check_invalid, msg_greater, msg_less);
	if(error_msg.length > 0)
		return error_msg;

	return error_msg;
}

function addstr(input_msg)
{
	var last_msg = "";
	var str_location;
	var temp_str_1 = "";
	var temp_str_2 = "";
	var str_num = 0;
	temp_str_1 = addstr.arguments[0];

	while(1)
	{
		str_location = temp_str_1.indexOf("%s");
		if(str_location >= 0)
		{
			str_num++;
			temp_str_2 = temp_str_1.substring(0,str_location);
			last_msg += temp_str_2 + addstr.arguments[str_num];
			temp_str_1 = temp_str_1.substring(str_location+2, temp_str_1.length);
			continue;
		}
		if(str_location < 0)
		{
			last_msg += temp_str_1;
			break;
		}
	}

	return last_msg;
}
*/






function getbits(value)
{
	var bits="";
	var bit;
	var i;

	// check value is number
	if(isNaN(value))
	    return false;
	
	// change value to bit string
	// example: 255 to 11111111
	for(i=0 ; i< 8 ; i++) {
	    bit = value % 2;
	    value = parseInt(value/2);
	    bits = bit + bits;
	}
	
	return(bits)
}

function isSubnetMask(maskArray)
{
	var flag=1;
	var isTrueMask=true;
	var i,j;
	var bits = new Array();
	
	for (i=0; i< 4; i++) {
	    bits[i] = getbits(maskArray[i]);
	}


	for (i=0; i<4; i++) {
	    for (j=0; j<8; j++) {
		if(bits[i].substr(j,1)==0)
		    flag=0;
		else if ( (flag==0) && (bits[i].substr(j,1)==1) )
		    isTrueMask=false;
	    }
	}

	return(isTrueMask);
}

function isTheSameIpRange(ipaddrArray, maskArray, checkIpArray)
{
	var theSameRange=true;

	for (i=0; i<4; i++) {
	    if( (ipaddrArray[i] & maskArray[i]) != (checkIpArray[i] & maskArray[i] ) )
		theSameRange = false;
	}
	
	return(theSameRange);

}

function isBlank(s)
{
	for (i=0;i<s.length;i++) 
	{
		c=s.charAt(i);
		if ((c!=' ') && (c!='\n') && (c!='\t'))
			return false;
	}
	return true;
}

var num=0;
function movenext(obj,j)
{
	var str,len,i;
	str = obj.value ;
	len = obj.value.length ;
	i = str.lastIndexOf(".",len);
	if (event.keyCode == 9)
	{
		document.forms[0].elements[j].focus();
		document.forms[0].elements[j].select();
		return true;
	}
	if (event.keyCode == 8 )
	{
		count = len - 1 ;
		if ( count == -1 && len == 0)
			num ++ ;
		if (num ==2 && j >=0)
		{
			num=0;
			document.forms[0].elements[j-1].focus();
			document.forms[0].elements[j-1].select();
			return true;
		}
	}
	if ( i == len-1 && i>0)
	{	
		len = len -1;
		str = str.slice(0,len);
		obj.value = str ;
		document.forms[0].elements[j+1].focus();
		document.forms[0].elements[j+1].select();
		return true;
	}
	if ( i == len-1 && i==0)
	{
		len = len -1;
		str = str.slice(0,len);
		obj.value = str ;
		return true;
	}
	if (len == 3)
	{
		document.forms[0].elements[j+1].focus();
		document.forms[0].elements[j+1].select();
		return true;
	}
}

function checkdot(obj,j)
{
	var str,len,i;
	str = obj.value ;
	len = obj.value.length ;
	i = str.lastIndexOf(".",len);
	if (event.keyCode == 9)
	{
		document.forms[0].elements[j].focus();
		document.forms[0].elements[j].select();
		return true;
	}
	if (event.keyCode == 8 )
	{
		count = len - 1 ;
		if ( count == -1 && len == 0)
			num ++ ;
		if (num ==2 && j >=0)
		{
			num=0;
			document.forms[0].elements[j-1].focus();
			document.forms[0].elements[j-1].select();
			return true;
		}
	}
	if ( i == len-1 && i==0)
	{
		len = len -1;
		str = str.slice(0,len);
		obj.value = str ;
		return true;
	}
	if ( i == len-1 && i!=0)
	{	
		len = len -1;
		str = str.slice(0,len);
		obj.value = str ;
		return true;
	}

} 

function movenextmac(obj,j)
{
	var len;
	len = obj.value.length ;
	if (len == 2)
	{
		document.forms[0].elements[j+1].focus();
		document.forms[0].elements[j+1].select();
		return true;
	}
}

