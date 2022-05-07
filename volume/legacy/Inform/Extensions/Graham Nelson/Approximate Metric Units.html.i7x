<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Extension</title><script type="text/javascript">	function showExtra(id, imid) {		if (document.getElementById(id).style.display == 'block') {			document.getElementById(id).style.display = 'none';			document.getElementById(imid).src = 'inform:/extra.png';		} else {			document.getElementById(id).style.display = 'block';			document.getElementById(imid).src = 'inform:/extraclose.png';		}	}    function openExtra(id, imid) {    	document.getElementById(id).style.display = 'block';    	document.getElementById(imid).src = 'inform:/extraclose.png';    }    function closeExtra(id, imid) {    	document.getElementById(id).style.display = 'none';    	document.getElementById(imid).src = 'inform:/extra.png';    }</script></head><STYLE TYPE="text/css"><!--*, *:before, *:after {-moz-box-sizing: border-box;-webkit-box-sizing: border-box;box-sizing: border-box;}.oval, .oval TD{background-image:url('inform:/doc_images/ovoid.png');color:white;}--></STYLE><body><script language="JavaScript">function pasteCode(code) {    var myProject = window.Project;    myProject.selectView('source');    myProject.pasteCode(code);}</script><font face="lucida grande,geneva,arial,tahoma,verdana,helvetica,helv" size=2><table CELLPADDING=0 CELLSPACING=0 width="100%" bgcolor="#000000"><tr><TD width=38px height=26px align="center" valign="center"><a href="inform:/Extensions/Extensions.html" border=0><img border=0 src="inform:/doc_images/Hookindex.png" border=0></a></td><TD width=38px height=26px align="center" valign="center"></td><td halign="left" valign="center" CELLPADDING=0 CELLSPACING=0><font color="#FFFFFF" size=2>Extensions</font></a></td><TD width=56px height=26px align="right" valign="center"><a href="inform:/index.html" border=0><img border=0 src="inform:/doc_images/Hookup.png" border=0></a></td></tr></table><p><a href="javascript:pasteCode('Include Approximate Metric Units by Graham Nelson.[=0x000A=][=0x000A=][=0x000A=]')"><img border=0 src=inform:/doc_images/paste.png></a>&nbsp;<b>Approximate Metric Units<font color="#404040"> by </font>Graham Nelson</b><p><small><p>Extension built in to Inform</small><p><p><hr><p>
<p>
 (Note: This extension uses integer arithmetic for its calculations, which was the best that could be done until June 2012. The new version of &quot;Metric Units&quot; uses floating-point calculations and is much more accurate, though it only works on versions of the Glulx virtual machine dating from 2011. This is a renamed copy of the old &quot;Metric Units&quot;, and is preserved in case people need it to keep older works running.)
<p>
 The metric system provides a consistent set of units for scientific measurement of the world. Though often associated with the French Revolution or with Napoleon, the system of metric units only really began to displace existing units in May 1875, when it was made official by an international treaty. In 1960, it was renamed the &quot;Système international d'unités&quot;, which is usually abbreviated &quot;SI&quot;.
<p>
 This extension is a kit for writers who want to make realistic simulations, backed up by some quantitative physics. It defines kinds of values for the 25 or so SI units in common usage, and more than 100 notations for them. It also makes sure they multiply correctly. For instance, a mass times an acceleration produces a force, so
<p>
<blockquote><font color="#000080"> say &quot;You feel a force of [2kg times 5 m/ss].&quot;</font></blockquote>
<p>
 will produce the text &quot;You feel a force of 10N.&quot; The easiest way to see how all these units combine is to run one of the examples below and look at the Kinds index which results.
<p>
 For each unit, both names and notations are allowed. Thus '2 kilograms' is equivalent to '2kg'. Both English and French spellings of 'meter'/'metre' and 'liter'/'litre' are allowed, but we insist on 'gram' not 'gramme' and 'tonne' not 'ton'. ('Ton' is too easily confused with the Imperial measure, which is not quite the same.) We can print back the same value in a variety of ways. For instance:
<p>
<blockquote><font color="#000080"> say &quot;[m0 in metric units]&quot;;<br> say &quot;[m0 in kg]&quot;;<br> say &quot;[m0 in g]&quot;;<br> say &quot;[m0 in kilograms]&quot;;</font></blockquote>
<p>
 might produce: '2.04kg', '2.04kg', '2040g', '2.04 kilograms'. The text expansion '... in metric units' prints any value of any of these units in its most natural notation: 2.04kg is thought to be better than 2040g, but 981g would be better than 0.981kg. Or in the case of our variant spellings:
<p>
<blockquote><font color="#000080"> say &quot;[C in metric units]&quot;;<br> say &quot;[C in milliliters]&quot;;<br> say &quot;[C in millilitres]&quot;;</font></blockquote>
<p>
 might produce '47 ml', '47 milliliters', '47 millilitres'. It's also worth remembering that any value can be rounded:
<p>
<blockquote><font color="#000080"> say &quot;[C to the nearest 5 ml]&quot;;</font></blockquote>
<p>
 would produce '45 ml', for instance.
<p>
 For detailed notes on each of the units, consult the Kinds index for any project using this extension.
<p>
 There are three main restrictions. First, Inform can only represent numbers within a certain range. Each kind of value is set up on the assumption that writers will want it to model human-scale situations - length, for instance, varies from 1mm, the smallest conscious movement a human can make, up to 2150km or so, the length of a continent-spanning footpath. 'Approximate Metric Units' is an extension to help with real-world physics questions like how long a plate dropped off the roof takes to hit the ground, or when a rope will break, or how long a saucepan of water will take to boil. It won't be much use for celestial events like lightning strikes, where enormous energies are released for fleeting periods of time, or for tiny subatomic events.
<p>
 Secondly, calculations are done with fixed-point arithmetic and will inevitably involve small rounding errors. Working out the same quantity by two different methods, which ought to have the same result according to physics, will often produce slightly different answers because these errors accumulate differently. 'Approximate Metric Units' aspires to help the writer to get physical answers which are about right, not to be a precision tool.
<p>
 Thirdly, we haven't included every SI unit. There are hundreds of kinds of value which turn up in physics, and we only include the commonest 25 or so. The missing ones which have named SI units are:
<p>
<blockquote><font color="#000080"> solid angle (measured in steradians), luminous flux (lux), electric capacitance (Farads), electric resistance (Ohms), electric conductance (Siemens), magnetic flux (Webers), magnetic field (Teslas), inductance (Henries), radioactivity (Becquerels), absorbed radioactive dose (Grays), equivalent radioactive dose (Sieverts), chemical quantity (mole), catalytic activity (katals).</font></blockquote>
<p>
 As can be seen, we've missed out units for chemistry, electromagnetic effects beyond the basic ones, and radioactivity. It would be easy to add any of these which might be needed:
<p>
<blockquote><font color="#000080"> Electric resistance is a kind of value.</font></blockquote>
<p>
<blockquote><font color="#000080"> 1 Ohm (in metric units, in Ohms, singular) or 2 Ohms (in metric units, in Ohms, plural) specifies an electric resistance scaled at 1000.</font></blockquote>
<p>
<blockquote><font color="#000080"> Electric resistance times electric current specifies a voltage.</font></blockquote>
<p>
 Similarly, there are many kinds of value which don't have named SI units, but where physicists write them down as compounds. These are also easy to add as needed:
<p>
<blockquote><font color="#000080"> Angular momentum is a kind of value.</font></blockquote>
<p>
<blockquote><font color="#000080"> 1 Nms specifies an angular momentum scaled at 1000.</font></blockquote>
<p>
<blockquote><font color="#000080"> Momentum times length specifies an angular momentum.</font></blockquote>
<p>
 Besides angular momentum, 'Approximate Metric Units' also leaves out:
<p>
<blockquote><font color="#000080"> volumetric flow (cu m/s), jerk (m/sss), snap (m/ssss), angular velocity (rad/s, though Inform would probably use degrees/s), torque (Nm), wavenumber (1/m), specific volume (cu m/kg), molar volume (cu m/mole), molar heat capacity (J/K/mol), molar energy (J/mol), specific energy (J/kg), energy density (J/cu m), surface tension (J/sq m), thermal conductivity (W/m/C), viscosity (sq m/s), conductivity (S/m), permittivity (F/m), permeability (H/m), electric field strength (V/m), magnetic field strength (A/m), resistivity (Ohm metre).</font></blockquote>
<p>
 This extension is pretty faithful to SI conventions. It chooses degrees rather than radians for angle, and centigrade rather than Kelvin for temperature, because these are more useful for humans and easier to represent in text. But otherwise it's strictly metric, and does not define Imperial measures. See the example below for how to add these.
<p>
 Example: ** Galileo, Galileo - Dropping a cannonball or a feather from a variety of heights.
<p>
 This experiment was first proposed in Pisa in the 1630s, but more definitively carried out by the crew of Apollo 15 in 1971, using a geological hammer and the feather of a falcon. Galileo's point was that heavy objects and light objects fall at the same speed because of gravity, and that only air resistance makes us think feathers fall more slowly than cannonballs. (Of course, heavy objects do land harder; the hammer kicked up a lot more lunar dust than the feather did.)
<p>
<blockquote><font color="#000080"><a href="javascript:pasteCode('[=0x0022=]Galileo, Galileo[=0x0022=][=0x000A=][=0x000A=]Include Approximate Metric Units by Graham Nelson.[=0x000A=][=0x000A=]The acceleration due to gravity is an acceleration that varies.[=0x000A=][=0x000A=]Laboratory is a room. [=0x0022=]An elegant Pisan room, with fine Renaissance panels, except for the teleport corridor to the east.[=0x0022=] A cannon ball and a feather are in the Laboratory.[=0x000A=][=0x000A=]Martian Outpost is east of the Laboratory. [=0x0022=]A reddish-lit room with steel walls, whose only exit is the teleport corridor to west.[=0x0022=][=0x000A=][=0x000A=]A room has an acceleration called gravitational field. The gravitational field of a room is usually 9.807 m/ss. The gravitational field of the Martian Outpost is 3.69 m/ss.[=0x000A=][=0x000A=]A thing has a mass. The mass of a thing is usually 10g. The mass of the cannon ball is 2kg.[=0x000A=][=0x000A=]Dropping it from is an action applying to one thing and one length.[=0x000A=][=0x000A=]Understand [=0x0022=]drop [thing] from [length][=0x0022=] as dropping it from.[=0x000A=][=0x000A=]Check dropping it from:[=0x000A=][=0x0009=]if the player is not holding the noun:[=0x000A=][=0x0009=][=0x0009=]say [=0x0022=]You would need to be holding that first.[=0x0022=] instead.[=0x000A=][=0x000A=]Check dropping it from:[=0x000A=][=0x0009=]if the length understood is greater than 3m:[=0x000A=][=0x0009=][=0x0009=]say [=0x0022=]Just how tall are you, exactly?[=0x0022=] instead.[=0x000A=][=0x000A=]Check dropping it from:[=0x000A=][=0x0009=]if the length understood is 0m:[=0x000A=][=0x0009=][=0x0009=]try dropping the noun instead.[=0x000A=][=0x000A=]Equation - Newton[=0x0027=]s Second Law[=0x000A=][=0x0009=][=0x0009=]F=ma[=0x000A=]where F is a force, m is a mass, a is an acceleration.[=0x000A=][=0x000A=]Equation - Principle of Conservation of Energy[=0x000A=][=0x0009=][=0x0009=]mgh = mv^2/2[=0x000A=]where m is a mass, h is a length, v is a velocity, and g is the acceleration due to gravity.[=0x000A=][=0x000A=]Equation - Galilean Equation for a Falling Body[=0x000A=][=0x0009=][=0x0009=]v = gt[=0x000A=]where g is the acceleration due to gravity, v is a velocity, and t is an elapsed time.[=0x000A=][=0x000A=]Carry out dropping something (called the falling body) from:[=0x000A=][=0x0009=]now the acceleration due to gravity is the gravitational field of the location;[=0x000A=][=0x0009=]let m be the mass of the falling body;[=0x000A=][=0x0009=]let h be the length understood;[=0x000A=][=0x0009=]let F be given by Newton[=0x0027=]s Second Law where a is the acceleration due to gravity;[=0x000A=][=0x0009=]say [=0x0022=]You let go [the falling body] from a height of [the length understood], and, subject to a downward force of [F], it falls. [=0x0022=];[=0x000A=][=0x0009=]now the noun is in the location;[=0x000A=][=0x0009=]let v be given by the Principle of Conservation of Energy;[=0x000A=][=0x0009=]let t be given by the Galilean Equation for a Falling Body;[=0x000A=][=0x0009=]let KE be given by KE = mv^2/2 where KE is an energy;[=0x000A=][=0x0009=]say [=0x0022=][t to the nearest 0.01s] later, this mass of [m] hits the floor at [v] with a kinetic energy of [KE].[=0x0022=];[=0x000A=][=0x0009=]if the KE is greater than 50J:[=0x000A=][=0x0009=][=0x0009=]say [=0x0022=][line break]This is not doing either the floor or your ears any favours.[=0x0022=][=0x000A=][=0x000A=]Test me with [=0x0022=]get ball / drop it from 1m / get ball / drop it from 2m / get ball / drop it from 3m / get ball / drop it from 3.2m / get ball / drop it from 0m / get all / east / drop ball from 3m / drop feather from 3m[=0x0022=].[=0x000A=][=0x000A=]')"><img border=0 src=inform:/doc_images/paste.png></a> &quot;Galileo, Galileo&quot;</font></blockquote>
<p>
<blockquote><font color="#000080"> Include Approximate Metric Units by Graham Nelson.</font></blockquote>
<p>
<blockquote><font color="#000080"> The acceleration due to gravity is an acceleration that varies.</font></blockquote>
<p>
<blockquote><font color="#000080"> Laboratory is a room. &quot;An elegant Pisan room, with fine Renaissance panels, except for the teleport corridor to the east.&quot; A cannon ball and a feather are in the Laboratory.</font></blockquote>
<p>
<blockquote><font color="#000080"> Martian Outpost is east of the Laboratory. &quot;A reddish-lit room with steel walls, whose only exit is the teleport corridor to west.&quot;</font></blockquote>
<p>
<blockquote><font color="#000080"> A room has an acceleration called gravitational field. The gravitational field of a room is usually 9.807 m/ss. The gravitational field of the Martian Outpost is 3.69 m/ss.</font></blockquote>
<p>
<blockquote><font color="#000080"> A thing has a mass. The mass of a thing is usually 10g. The mass of the cannon ball is 2kg.</font></blockquote>
<p>
<blockquote><font color="#000080"> Dropping it from is an action applying to one thing and one length.</font></blockquote>
<p>
<blockquote><font color="#000080"> Understand &quot;drop [thing] from [length]&quot; as dropping it from.</font></blockquote>
<p>
<blockquote><font color="#000080"> Check dropping it from:<br>&nbsp;&nbsp;&nbsp;&nbsp; if the player is not holding the noun:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; say &quot;You would need to be holding that first.&quot; instead.</font></blockquote>
<p>
<blockquote><font color="#000080"> Check dropping it from:<br>&nbsp;&nbsp;&nbsp;&nbsp; if the length understood is greater than 3m:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; say &quot;Just how tall are you, exactly?&quot; instead.</font></blockquote>
<p>
<blockquote><font color="#000080"> Check dropping it from:<br>&nbsp;&nbsp;&nbsp;&nbsp; if the length understood is 0m:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; try dropping the noun instead.</font></blockquote>
<p>
<blockquote><font color="#000080"> Equation - Newton's Second Law<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; F=ma<br> where F is a force, m is a mass, a is an acceleration.</font></blockquote>
<p>
<blockquote><font color="#000080"> Equation - Principle of Conservation of Energy<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mgh = mv^2/2<br> where m is a mass, h is a length, v is a velocity, and g is the acceleration due to gravity.</font></blockquote>
<p>
<blockquote><font color="#000080"> Equation - Galilean Equation for a Falling Body<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v = gt<br> where g is the acceleration due to gravity, v is a velocity, and t is an elapsed time.</font></blockquote>
<p>
<blockquote><font color="#000080"> Carry out dropping something (called the falling body) from:<br>&nbsp;&nbsp;&nbsp;&nbsp; now the acceleration due to gravity is the gravitational field of the location;<br>&nbsp;&nbsp;&nbsp;&nbsp; let m be the mass of the falling body;<br>&nbsp;&nbsp;&nbsp;&nbsp; let h be the length understood;<br>&nbsp;&nbsp;&nbsp;&nbsp; let F be given by Newton's Second Law where a is the acceleration due to gravity;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;You let go [the falling body] from a height of [the length understood], and, subject to a downward force of [F], it falls. &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; now the noun is in the location;<br>&nbsp;&nbsp;&nbsp;&nbsp; let v be given by the Principle of Conservation of Energy;<br>&nbsp;&nbsp;&nbsp;&nbsp; let t be given by the Galilean Equation for a Falling Body;<br>&nbsp;&nbsp;&nbsp;&nbsp; let KE be given by KE = mv^2/2 where KE is an energy;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;[t to the nearest 0.01s] later, this mass of [m] hits the floor at [v] with a kinetic energy of [KE].&quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; if the KE is greater than 50J:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; say &quot;[line break]This is not doing either the floor or your ears any favours.&quot;</font></blockquote>
<p>
<blockquote><font color="#000080"> Test me with &quot;get ball / drop it from 1m / get ball / drop it from 2m / get ball / drop it from 3m / get ball / drop it from 3.2m / get ball / drop it from 0m / get all / east / drop ball from 3m / drop feather from 3m&quot;.</font></blockquote>
<p>
 Note the way Inform is able to solve the conservation equation, which says the potential energy at the start equals the kinetic energy at the end, to find the velocity v: this involves taking a square root, but it all happens automatically. Square roots tend to cause rounding errors - so on Mars the cannon ball and feather actually land 0.02s apart, in the calculation above, despite Galileo. But no human observer would notice that discrepancy.
<p>
 Example: ** The Empire Strikes Back - Using good old Imperial measures of length and area alongside these Frenchified metric ones.
<p>
 Imperial measures, often going back to obscure customs in Anglo-Saxon England, were inflicted across much of the world in the heyday of the British Empire. Some are still very much alive in England and its former colonies (Australia, India, New Zealand, Canada, Ireland, the USA and so on) - miles and feet, for instance. Others continue only in unscientific social customs, like sport: horse-races are measured in furlongs; the running distance between the two wickets of a cricket pitch is 22 yards, which is 1 chain exactly; and even in France, a football goal must be 8 feet high and 8 yards wide.
<p>
<blockquote><font color="#000080"><a href="javascript:pasteCode('[=0x0022=]The Empire Strikes Back[=0x0022=][=0x000A=][=0x000A=]Include Approximate Metric Units by Graham Nelson.[=0x000A=][=0x000A=]Steeple Aston Cricket Pitch is a room.[=0x000A=][=0x000A=]1 inch (in imperial units, in inches, singular) or 2 inches (in imperial units, in inches, plural) specifies a length equivalent to 2.5cm.[=0x000A=]1 foot (in imperial units, in feet, singular) or 2 feet (in imperial units, in feet, plural) specifies a length equivalent to 12 inches.[=0x000A=]1 yard (in imperial units, in yards, singular) or 2 yards (in imperial units, in yards, plural) specifies a length equivalent to 3 feet.[=0x000A=]1 chain (in imperial units, in chains, singular) or 2 chains (in imperial units, in chains, plural) specifies a length equivalent to 22 yards.[=0x000A=]1 furlong (in imperial units, in furlongs, singular) or 2 furlongs (in imperial units, in furlongs, plural) specifies a length equivalent to 10 chains.[=0x000A=]1 mile (in imperial units, in miles, singular) or 2 miles (in imperial units, in miles, plural) specifies a length equivalent to 8 furlongs.[=0x000A=]1 league (in imperial units, in leagues, singular) or 2 leagues (in imperial units, in leagues, plural) specifies a length equivalent to 3 miles.[=0x000A=][=0x000A=]1 square foot (in imperial units, in square feet, singular) or 2 square feet (in imperial units, in square feet, plural) specifies an area equivalent to 900 sq cm.[=0x000A=]1 square yard (in imperial units, in square yards, singular) or 2 square yards (in imperial units, in square yards, plural) specifies an area equivalent to 9 square feet.[=0x000A=]1 acre (in imperial units, in acres, singular) or 2 acres (in imperial units, in acres, plural) specifies an area equivalent to 4840 square yards.[=0x000A=][=0x000A=]Understand [=0x0022=]convert [a length][=0x0022=] as converting. Converting is an action applying to one length.[=0x000A=][=0x000A=]Carry out converting:[=0x000A=][=0x0009=]let A be the length understood;[=0x000A=][=0x0009=]say [=0x0022=]Measuring A = [A], which [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in millimetres] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in centimetres] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in metres] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in kilometres] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in inches] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in feet] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in yards] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in chains] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in furlongs] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in miles] [=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]= [A in leagues].[=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]Metric: [A in metric units].[=0x0022=];[=0x000A=][=0x0009=]say [=0x0022=]Imperial: [A in Imperial units].[paragraph break][=0x0022=];[=0x000A=][=0x000A=]Test me with [=0x0022=]convert 1.2m / convert 2m / convert 30cm / convert 20 chains[=0x0022=].[=0x000A=][=0x000A=]')"><img border=0 src=inform:/doc_images/paste.png></a> &quot;The Empire Strikes Back&quot;</font></blockquote>
<p>
<blockquote><font color="#000080"> Include Approximate Metric Units by Graham Nelson.</font></blockquote>
<p>
<blockquote><font color="#000080"> Steeple Aston Cricket Pitch is a room.</font></blockquote>
<p>
<blockquote><font color="#000080"> 1 inch (in imperial units, in inches, singular) or 2 inches (in imperial units, in inches, plural) specifies a length equivalent to 2.5cm.<br> 1 foot (in imperial units, in feet, singular) or 2 feet (in imperial units, in feet, plural) specifies a length equivalent to 12 inches.<br> 1 yard (in imperial units, in yards, singular) or 2 yards (in imperial units, in yards, plural) specifies a length equivalent to 3 feet.<br> 1 chain (in imperial units, in chains, singular) or 2 chains (in imperial units, in chains, plural) specifies a length equivalent to 22 yards.<br> 1 furlong (in imperial units, in furlongs, singular) or 2 furlongs (in imperial units, in furlongs, plural) specifies a length equivalent to 10 chains.<br> 1 mile (in imperial units, in miles, singular) or 2 miles (in imperial units, in miles, plural) specifies a length equivalent to 8 furlongs.<br> 1 league (in imperial units, in leagues, singular) or 2 leagues (in imperial units, in leagues, plural) specifies a length equivalent to 3 miles.</font></blockquote>
<p>
<blockquote><font color="#000080"> 1 square foot (in imperial units, in square feet, singular) or 2 square feet (in imperial units, in square feet, plural) specifies an area equivalent to 900 sq cm.<br> 1 square yard (in imperial units, in square yards, singular) or 2 square yards (in imperial units, in square yards, plural) specifies an area equivalent to 9 square feet.<br> 1 acre (in imperial units, in acres, singular) or 2 acres (in imperial units, in acres, plural) specifies an area equivalent to 4840 square yards.</font></blockquote>
<p>
<blockquote><font color="#000080"> Understand &quot;convert [a length]&quot; as converting. Converting is an action applying to one length.</font></blockquote>
<p>
<blockquote><font color="#000080"> Carry out converting:<br>&nbsp;&nbsp;&nbsp;&nbsp; let A be the length understood;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;Measuring A = [A], which &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in millimetres] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in centimetres] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in metres] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in kilometres] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in inches] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in feet] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in yards] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in chains] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in furlongs] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in miles] &quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;= [A in leagues].&quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;Metric: [A in metric units].&quot;;<br>&nbsp;&nbsp;&nbsp;&nbsp; say &quot;Imperial: [A in Imperial units].[paragraph break]&quot;;</font></blockquote>
<p>
<blockquote><font color="#000080"> Test me with &quot;convert 1.2m / convert 2m / convert 30cm / convert 20 chains&quot;.</font></blockquote>
<p>
 The above conversions are based on 1 inch equals 2.5cm, which is not very accurate: 2.54cm would be closer. But to get that accuracy we would need to represent lengths down to 0.4mm, which is below the 1mm cutoff imposed by 'Metric Units'. We'll accept this 2% error in lengths (or 4% error in areas) as harmless, given that we're not going to be doing any serious calculations in Imperial units; if we were, we'd do better to make a fresh extension for them.
<p>
 Confusions still cause spectacular failures, as when an Air Canada ground crew mixed up pounds and kilograms and fuelled a Boeing 767 so lightly in 1983 that it ran dry at 41,000 feet, losing all engines, avionics and electricity. The captain, by great good luck also an amateur glider pilot, made a now-legendary landing at an obscure airstrip which the first officer by great good luck had once flown from. The USA's Mars Climate Orbiter spacecraft, whose navigation software confused pounds and newtons, was not so lucky and burned up in the Martian atmosphere in 1998 at a cost of $330 million.
<p>

<p>
<p></body></html>