//****************************************************************
// The modify is by company product.
// Modified: Zachary Chang (zacharyc@justezy.com.tw) by November 2001
//
//**************************************************************** 
// You are free to copy the "Folder-Tree" script as long as you	
// keep this copyright notice: 
// Script found in: http://www.geocities.com/marcelino_martins/foldertree.html
// Author: Marcelino Alves Martins (http://www.mmartins.com) 
// 1997--2001. 
// Modified: Patrick Hess (posi@posi.de) March 2000, October 2001

//					 changed: global variables define the path to the

//										.gif files (classPath), the names of the

//										images (ftv2folderopen, ftv2*, ...) and the

//										destination frame (basefrm)

//**************************************************************** 
 
// Log of changes: 
//	 07 Nov 01 - Modify for company product
//			 10 Aug 01 - Support for Netscape 6
//
//			 17 Feb 98 - Fix initialization flashing problem with Netscape
//			 
//			 27 Jan 98 - Root folder starts open; support for USETEXTLINKS; 
//									 make the ftien4 a js file 
 
 
// Definition of class Folder 
// ***************************************************************** 

function FoldTable(iconTable) //constructor 
{ 
	//constant data 
	this.desc = "" //folderDescription 
	this.hreference = ""//hreference 
	this.id = -1	 
	this.navObj = 0	
	this.iconImg = 0	
	this.nodeImg = 0	
 
	//dynamic data 
	this.isOpen = true 
	this.iconHeadFooter = iconTable	
	this.children = new Array 
	this.nChildren = 0 
 
	//methods 
	this.initialize = initializeTable 
	this.setState = setStateFolder 
	this.addChild = addChild 
	this.createIndex = createEntryIndex 
	this.escondeBlock = escondeBlock
	this.esconde = escondeFolder 
	this.mostra = mostra 
	this.renderOb = drawTable 
	this.totalHeight = totalHeight 
	this.subEntries = folderSubEntries 
	this.outputLink = outputFolderLink 
	this.blockStart = blockStart
	this.blockEnd = blockEnd
}

function Folder(folderDescription, hreference, iconSrc, descMsg) //constructor 
{ 
	//constant data 
	this.desc = folderDescription 
	this.hreference = hreference 
	this.descMsg = descMsg
	this.id = -1	 
	this.navObj = 0	
	this.iconImg = 0	
	this.nodeImg = 0	
	this.isLastNode = 0 
 
	//dynamic data 
	this.isOpen = true 
	this.iconSrc = iconSrc
	this.iconSpaceHolder =  imgSpaceHolder 
	this.children = new Array 
	this.nChildren = 0 
 
	//methods 
	this.initialize = initializeFolder 
	this.setState = setStateFolder 
	this.addChild = addChild 
	this.createIndex = createEntryIndex 
	this.escondeBlock = escondeBlock
	this.esconde = escondeFolder 
	this.mostra = mostra 
	this.renderOb = drawFolder 
	this.totalHeight = totalHeight 
	this.subEntries = folderSubEntries 
	this.outputLink = outputFolderLink 
	this.blockStart = blockStart
	this.blockEnd = blockEnd
} 

 
function initializeTable(level, lastNode, leftSide) 
{ 
	
	var j=0 
	var i=0 
	var nc 
			
	nc = this.nChildren 
	 
	this.createIndex() 
	this.renderOb() 
		
			
	if (nc > 0) 
	{ 
		level = level + 1 
		for (i=0 ; i < this.nChildren; i++)	
		{ 
			if (i == this.nChildren-1) 
				this.children[i].initialize(level, 1, leftSide) 
			else 
				this.children[i].initialize(level, 0, leftSide) 
			} 
	} 
	
} 
 
 
function initializeFolder(level, lastNode, leftSide) 
{ 
	var j=0 
	var i=0 
	var numberOfFolders 
	var numberOfDocs 
	var nc 
			
	nc = this.nChildren 
	 
	this.createIndex() 
	if (level>0) 
		if (lastNode) //the last child in the children array 
		{ 
			this.renderOb(leftSide) 
			this.isLastNode = 1 
		} 
		else 
		{ 
			this.renderOb(leftSide) 
			this.isLastNode = 0 
		} 
	else 
		this.renderOb("") 
	 
	if (nc > 0) 
	{ 
		level = level + 1 
		for (i=0 ; i < this.nChildren; i++)	
		{ 
			//if (i == this.nChildren-1) 
				this.children[i].initialize() 
		 // else 
			//	this.children[i].initialize(level, 0, leftSide) 
			} 
	} 
} 
 
function setStateFolder(isOpen) 
{ 
	var subEntries 
	var totalHeight 
	var fIt = 0 
	var i=0 
 
	if (isOpen == this.isOpen) 
		return 
 
	if (browserVersion == 2)	
	{ 
		totalHeight = 0 
		for (i=0; i < this.nChildren; i++) 
			totalHeight = totalHeight + this.children[i].navObj.clip.height 
			subEntries = this.subEntries() 
		if (this.isOpen) 
			totalHeight = 0 - totalHeight 
		for (fIt = this.id + subEntries + 1; fIt < nEntries; fIt++) 
			indexOfEntries[fIt].navObj.moveBy(0, totalHeight) 
	}	
	this.isOpen = isOpen 
	propagateChangesInState(this) 
} 
 
function propagateChangesInState(folder) 
{	 
	var i=0 
 
	if (folder.isOpen) 
		for (i=0; i<folder.nChildren; i++) 
			folder.children[i].mostra() 
	else 
		for (i=0; i<folder.nChildren; i++) 
			folder.children[i].esconde() 
} 
 
function escondeFolder() 
{ 
	this.escondeBlock()
	 
	this.setState(0) 
} 
 
function drawTable() 
{ 
	var idParam = "id='folder" + this.id + "'"

	if (browserVersion == 2) { 
		if (!doc.yPos) 
			doc.yPos = nPostLocal 
	} 


	this.blockStart("folder","1")
/*
	doc.write("<tr width='160' height='5'><td>") 
	doc.write("<img id='folderIcon" + this.id + "' name='folderIcon" + this.id + "' src='" + this.iconHeadFooter+"' border=0></a>") 
	doc.write("</td>")	
*/	
	this.blockEnd()

 
	if (browserVersion == 1) { 
		this.navObj = doc.all["folder"+this.id] 
		this.iconImg = doc.all["folderIcon"+this.id] 
		this.nodeImg = doc.all["nodeIcon"+this.id] 
	} else if (browserVersion == 2) { 
		this.navObj = doc.layers["folder"+this.id] 
		this.iconImg = this.navObj.document.images["folderIcon"+this.id] 
		this.nodeImg = this.navObj.document.images["nodeIcon"+this.id] 
		doc.yPos=doc.yPos+this.navObj.clip.height 
	} else if (browserVersion == 3) { 
		this.navObj = doc.getElementById("folder"+this.id)
		this.iconImg = doc.getElementById("folderIcon"+this.id) 
		this.nodeImg = doc.getElementById("nodeIcon"+this.id)
	} 

} 
	
 
function drawFolder(leftSide) 
{ 
	var idParam = "id='folder" + this.id + "'"
/*
	if (browserVersion == 2) { 
		if (!doc.yPos) 
			doc.yPos=20 
	} 
*/
	this.blockStart("folder")

	doc.write("<tr>") 

	doc.write("<td width='1%'>") 
	doc.write("<img name='folderIcon' src='" + this.iconSpaceHolder +"' border=0 width=3>")
	doc.write("</td>")				
	 
	doc.write("<td>")
	this.outputLink()
	doc.write("<img name='folderIcon' src='" + this.iconSrc+"' border=0 >")
	doc.write("</a>")
	doc.write("</td>")	 
	
	doc.write("<td width='1%'>") 
	this.outputLink()
	doc.write("<img name='folderIcon' src='" + this.iconSpaceHolder+"' border=0 width=3>")
	doc.write("</a>")
	doc.write("</td>")				
		 	

	doc.write("<td nowrap>") 
	this.outputLink()
	doc.write("<FONT CLASS=\"HEAD1\">")
	doc.write( this.desc ) 
	doc.write(" </FONT>")
	doc.write("</a>")	// zachary
	doc.write("</td>")				
	
	this.outputLink()
	doc.write("<td width='96%'>") 
	doc.write("&nbsp;")
	doc.write("</td>")				
	doc.write("</a>")

	doc.write("</tr>") 

	this.blockEnd()
 
	if (browserVersion == 1) { 
		this.navObj = doc.all["folder"+this.id] 
		this.iconImg = doc.all["folderIcon"+this.id] 
		this.nodeImg = doc.all["nodeIcon"+this.id] 
	} else if (browserVersion == 2) { 
		this.navObj = doc.layers["folder"+this.id] 
		this.iconImg = this.navObj.document.images["folderIcon"+this.id] 
		this.nodeImg = this.navObj.document.images["nodeIcon"+this.id] 
		doc.yPos=doc.yPos+this.navObj.clip.height 
	} else if (browserVersion == 3) { 
		this.navObj = doc.getElementById("folder"+this.id)
		this.iconImg = doc.getElementById("folderIcon"+this.id) 
		this.nodeImg = doc.getElementById("nodeIcon"+this.id)
	} 
} 


function info_mouseOver( string )
{
	//alert( "info_mouseOver---" + string );
//	top.code._timeoutId = setTimeout("top.code.info_show(\""+string+"\" , \"status\" );", 500);
	return true;
}


function info_mouseOut()
{
	//alert( "info_mouseOut" );
//	if( top.code._timeoutId != -1) {
//		clearTimeout(top.code._timeoutId);
//		top.code._timeoutId = -1;
//	}
	return true;
}


function outputFolderLink() 
{ 
	if (this.hreference) 
	{ 
		doc.write("<a href=\"" + this.hreference + "\"	onClick='javascript:clickOnFolder("+this.id+")' ") 
	} 
	else 
		doc.write("<a href='javascript:clickOnNode("+this.id+")' ")	 

	if (this.descMsg)
		doc.write("onMouseOver=\"info_mouseOver('" + this.descMsg + "')\" onMouseOut=\"info_mouseOut()\" ");
	doc.write(">") 
		
} 
 
function addChild(childNode) 
{ 
	this.children[this.nChildren] = childNode 
	this.nChildren++ 
	return childNode 
} 
 
function folderSubEntries() 
{ 
	var i = 0 
	var se = this.nChildren 
 
	for (i=0; i < this.nChildren; i++){ 
		if (this.children[i].children) //is a folder 
			se = se + this.children[i].subEntries() 
	} 
 
	return se 
} 
 
 
// Definition of class Item (a document or link inside a Folder) 
// ************************************************************* 
 
function Item(itemDescription, itemLink, descMsg) // Constructor 
{ 
	// constant data 
	this.desc = itemDescription 
	this.link = itemLink 
	this.descMsg = descMsg
	this.id = -1 //initialized in initalize() 
	this.navObj = 0 //initialized in render() 
	this.navObjBgRing = 0
	this.navObjNormal = 0
	this.iconImg = 0 // 
	this.iconSrc =  imgArrow
	this.iconSpaceHolder =  imgSpaceHolder 
	this.BgRingColor = "#FF6600"	// for NS
 
	// methods 
	this.initialize = initializeItem 
	this.createIndex = createEntryIndex 
	this.esconde = escondeBlock
	this.mostra = mostra 
	this.renderOb = drawItem 
	this.renderObBgRing = drawItemBgRing
	this.drawItemHtml = drawItemHtml
	this.totalHeight = totalHeight 
	this.blockStart = blockStart
	this.blockEnd = blockEnd
	this.outputLink = outputItemLink 
	this.changeBGColor = changeBGColor
	
} 
 
function initializeItem() 
{	
	this.createIndex() 
	this.renderOb()
	if (browserVersion == 2)	
		 this.renderObBgRing()		
} 
 
function drawItemHtml(state)
{
	if ( state == "ring" )
	{
		doc.yPos=this.navObj.top 
		this.blockStart("itemBG")
	}
	else	
		this.blockStart("item")

	doc.write("<tr>")
/*	
	doc.write("<td width='1%'>") 
	doc.write("<img src='" + this.iconSpaceHolder +"' border=0 ")
	nInsTableHeight = nSubTableHeight + 4
	doc.write("width='"+ nSubCreaseWidth +"' height='"+ nInsTableHeight +"'>")
	doc.write("</td>") 
*/	
	// ***************************
		
	doc.write("<td ");
	doc.write(" ALIGN='CENTER' VALIGN='middle'	");
	if ( state == "ring" )
		doc.write("bgcolor='" + this.BgRingColor + "' ");
	doc.write(">");
	

	doc.write("<TABLE cellspacing='0' cellpadding='0' border='0' ")
	doc.write("width='100%'	height='"+ nSubTableHeight +"'>")
	
	//doc.write("<TR BGCOLOR = '#5E96C8'>")		
	doc.write("<TR CLASS=\"SUBBAR\" ")		
	if (browserVersion == 1 || browserVersion == 3) 
		doc.write("id='itemSub"+ this.id +"'	");
	doc.write(" >");
	
	doc.write("<td width='1%'>") 
	doc.write("<img src='" + this.iconSpaceHolder +"' border=0 width=7>")
	doc.write("</td>")	 
	
	
	doc.write("<td width='1%'>") 
	//doc.write("<a href=" + this.link + "	onclick='javascript:clickEndNode("+ this.id +")'>") 
	this.outputLink();
	if (browserVersion == 1 || browserVersion == 3) 
		doc.write("<img id='itemIcon"+this.id+"'	") 
	doc.write("src='"+this.iconSrc+"' border=0>") 
	doc.write("</a>") 
	doc.write("</td>")
	
	doc.write("<td width='1%'>") 
	doc.write("<img src='" + this.iconSpaceHolder +"' border=0 width=7>")
	doc.write("</td>")	 
	
	doc.write("<td valign=middle nowrap>") 
	if (USETEXTLINKS) 
	{
		//doc.write("<a href=" + this.link + " onclick='javascript:clickEndNode("+ this.id +")'>")
		this.outputLink()
		doc.write("<FONT  ")
	        if (browserVersion == 1 || browserVersion == 3) 
		   doc.write("id='itemSubFont"+ this.id +"'	");
		doc.write("CLASS=\"HEAD2\">" + this.desc + "</FONT></a>") 
	}
	else 
		doc.write(this.desc) 
	doc.write("</td>")
	
	//doc.write("<a href=" + this.link + "	onclick='javascript:clickEndNode("+ this.id +")'>") 
	this.outputLink();
	doc.write("<td width='94%'>") 
	doc.write("&nbsp;")
	doc.write("</td>")				
	doc.write("</a>")
 
	doc.write("</tr>")
	doc.write("</table>")
	
	doc.write("</td>")
	
	doc.write("</tr>")	


	this.blockEnd()
	
	if (browserVersion == 1 || browserVersion == 3) 
	{ 
		this.navObj = doc.all["item"+this.id] 
		this.iconImg = doc.all["itemIcon"+this.id] 
		this.navObjBgRing = doc.all["itemSub"+this.id] 
		this.navObjSubFont = doc.all["itemSubFont"+this.id]
	} 
	else if (browserVersion == 2) 
	{ 
		if ( state == "ring" )
		{	
				this.navObjBgRing = doc.layers["itemBG"+this.id] 
				//this.navObjNormal = this.navObj;
				this.iconImg = this.navObj.document.images["itemIcon"+this.id] 
				doc.yPos=doc.yPos+this.navObjBgRing.clip.height 
				this.navObjBgRing.visibility = "hidden"
		} 
		else if ( state == "normal" )
		{
				this.navObj = doc.layers["item"+this.id] 
				this.navObjNormal = this.navObj;
				this.iconImg = this.navObj.document.images["itemIcon"+this.id] 
				doc.yPos=doc.yPos+this.navObj.clip.height
						 	
		}			
	} 
//	else if (browserVersion == 3) 
//	{ 
//			this.navObj = doc.getElementById("item"+this.id)
//			//this.iconImg = doc.getElementById("itemIcon"+this.id)
//			this.navObjBgRing = doc.getElementById("itemSub"+this.id)
//			this.navObjSubFont = doc.getElementById("itemSubFont"+this.id)
//
//			
//	}				
} 
 
function drawItemBgRing()
{
	this.drawItemHtml("ring");
} 
 
function drawItem() 
{ 
	this.drawItemHtml("normal");
} 
 

function outputItemLink() 
{ 
	doc.write("<a href=" + this.link + "	onclick='javascript:clickEndNode("+ this.id +")' ");
	if (this.descMsg)
		doc.write("onMouseOver=\"info_mouseOver('" + this.descMsg + "')\" onMouseOut=\"info_mouseOut()\" ");

	doc.write(">");
	
} 
 
// Methods common to both objects (pseudo-inheritance) 
// ******************************************************** 
 
function mostra() 
{ 
	if (browserVersion == 1 || browserVersion == 3) 
		this.navObj.style.display = "block" 
	else 
		this.navObj.visibility = "show" 
} 

function escondeBlock() 
{ 
	if (browserVersion == 1 || browserVersion == 3) { 
		if (this.navObj.style.display == "none") 
			return 
		this.navObj.style.display = "none" 
	} else { 
		if (this.navObj.visibility == "hidden") 
			return 
		this.navObj.visibility = "hidden" 
	}		 
} 
 
 
// 
// The isTable is flag for head & foot table image .
// 
function blockStart(idprefix, isTable) {
	var idParam = "id='" + idprefix + this.id + "'"

	if (browserVersion == 2) // NS4
		doc.write("<layer "+ idParam + " top=" + doc.yPos + " left=" + nPostLeft	+ " visibility=show>") 
	if (browserVersion == 3) //N6 has bug on display property with tables
		doc.write("<div " + idParam + " style='display:block; position:block;'>")

	if (isTable)		 
		doc.write("<table border=0 cellspacing=0 cellpadding=0 width='"+ nTableWidth +"'") 
	else
		//doc.write("<table border=0 cellspacing=0 cellpadding=0 bgcolor='#004D9C' height='"+ nTableHeight +"' width='"+ nTableWidth +"'") 
		doc.write("<table CLASS=MAINBAR border=0 cellspacing=0 cellpadding=0 height='"+ nTableHeight +"' width='"+ nTableWidth +"'") 

	if (browserVersion == 1) // IE
		doc.write(idParam + " style='display:block; position:block; '>") 
	else
		doc.write(">") 
}

function blockEnd() {
	doc.write("</table>") 
	 
	if (browserVersion == 2) 
		doc.write("</layer>") 
	if (browserVersion == 3) 
		doc.write("</div>") 
}
 
function createEntryIndex() 
{ 
	this.id = nEntries 
	indexOfEntries[nEntries] = this 
	nEntries++ 
} 
 
// total height of subEntries open 
function totalHeight() //used with browserVersion == 2 
{ 
	var h = this.navObj.clip.height 
	var i = 0 
	 
	if (this.isOpen) //is a folder and _is_ open 
		for (i=0 ; i < this.nChildren; i++)	
			h = h + this.children[i].totalHeight() 
 
	return h 
} 

	
function changeBGColor()
{ 
	if (browserVersion == 1 || browserVersion == 3) 
	{ 
			if ( oldNavObjBgRing != null ) {
					//oldNavObjBgRing.className = 'MAINBAR';
					oldNavObjBgRing.className = 'SUBBAR';
					oldNavObjSubFont.className = 'HEAD2';
					oldNavObjIcon.src = imgArrow;
		        }
			
			this.navObjBgRing.className = 'ITEMACT'; 
			oldNavObjBgRing = this.navObjBgRing;
			
			this.navObjSubFont.className = 'HEAD3';
			oldNavObjSubFont = this.navObjSubFont;

			this.iconImg.src = imgChangeArrow;
			oldNavObjIcon = this.iconImg;
	
	} 
	else if (browserVersion == 2) 
		{ 
			if (this.navObj != this.navObjBgRing)
			{	
				if ( oldNavObjBgRing != null )
				{
		 		oldNavObjBgRing.navObjNormal.top = oldNavObjBgRing.navObj.top
		 		oldNavObjBgRing.navObjNormal.visibility = oldNavObjBgRing.navObj.visibility
		 		oldNavObjBgRing.navObj.visibility = "hidden"
		 		oldNavObjBgRing.navObj = oldNavObjBgRing.navObjNormal;
				}
		 	
				this.navObjBgRing.top = this.navObj.top
		this.navObjBgRing.visibility = this.navObj.visibility
		this.navObj.visibility = "hidden"
	this.navObj = this.navObjBgRing;
		
		oldNavObjBgRing = this;
			}
	 } 
	 //else if (browserVersion == 3) 
	 //{

	 //}
} 

 
// Events 
// ********************************************************* 
 
function clickOnFolder(folderId) 
{ 
	var clicked = indexOfEntries[folderId] 
 
	if (!clicked.isOpen) 
		clickOnNode(folderId) 
 
	return	
 
	if (clicked.isSelected) 
		return 
} 
 
function clickOnNode(folderId) 
{ 
	var clickedFolder = 0 
	var state = 0 
 
	clickedFolder = indexOfEntries[folderId] 
	state = clickedFolder.isOpen 
 
	clickedFolder.setState(!state) //open<->close	
} 
 
	
function clickEndNode(itemId) 
{ 
	var clickedItem = 0 
	clickedItem = indexOfEntries[itemId] 
	clickedItem.changeBGColor()
	
} 
// Auxiliary Functions for Folder-Tree backward compatibility 
// *********************************************************** 
 
	
function gFldTable(iconTable) 
{ 
	folder = new FoldTable(iconTable) 
	return folder 
} 
	
 
function gFld(description, hreference, headIconSrc, descMsg) 
{ 
	folder = new Folder(description, hreference, headIconSrc, descMsg) 
	return folder 
} 
	 
 
function gLnk(target, description, linkData, descMsg) 
{ 
	fullLink = linkData + " target=\""+basefrm+"\" " 
 
	linkItem = new Item(description, fullLink, descMsg)	 
	return linkItem 
} 
 
function insFld(parentFolder, childFolder) 
{ 
	return parentFolder.addChild(childFolder) 
} 
 
function insDoc(parentFolder, document) 
{ 
	parentFolder.addChild(document) 
} 
 

// Global variables 
// **************** 
 
//These two variables are overwriten on defineMyTree.js if needed be
//USETEXTLINKS = 0 
//STARTALLOPEN = 0
indexOfEntries = new Array 
nEntries = 0 
doc = document 
browserVersion = 0 
selectedFolder=0
var foldName = null;
nTableWidth = 0
nSubCreaseWidth = 10
nTableHeight = 22
nSubTableHeight = 22
nSubCreaseWidth = 10
oldNavObjBgRing = null;
oldNavObjSubFont = null;
oldNavObjIcon = null;
nPostLocal = 5
nPostLeft = 8



// Main function
// ************* 

// This function uses an object (navigator) defined in
// ua.js, imported in the main html page (left frame).
function initializeDocument(foldName) 
{ 
	switch(navigator.family)
	{
		case 'ie4':
      			browserVersion = 1 //Simply means IE > 3.x
      			break;
    		case 'nn4':
      			browserVersion = 2 //NS4.x 
      			break;
    		case 'gecko':
      			browserVersion = 3 //NS6.x
      			break;
      		case 'safari':
      			browserVersion = 3 //Safari Beta 3 seems to behave like IE in spite of being based on Konkeror
      			break;
		default:
      			browserVersion = 3 //other, possibly without DHTML  
      		break;
	}	 
	
	if (screen.width == 800)	
	{ 
		nTableWidth = 155;		// for screen 800x600
		nPostLeft = 4;
	}	
	else
	{ 
//		nTableWidth = 183;		// for screen 1024x768
		nTableWidth = 160;		// for screen 1024x768
		nPostLeft = 3;
	}		 

	//foldersTree (with the site's data) is created in an external .js 
	//foldersTree.initialize(0, 1, "") 
	foldName.initialize(0, 1, "") 
	//foldName.display()

		
	if (browserVersion == 2) 
		doc.write("<layer top="+indexOfEntries[nEntries-1].navObj.top+">&nbsp;</layer>") 

	//The tree starts in full display 
	if (!STARTALLOPEN)
		if (browserVersion > 0) {
		// close the whole tree 
		clickOnNode(0) 
		// open the root folder 
		clickOnNode(0) 
		} 

	/* not used, ph 10/2001
	if (browserVersion == 0) 
	doc.write("<table border=0><tr><td><br><br><font size=-1>This tree only expands or contracts with DHTML capable browsers</font></table>")
	*/
} 
 
