package oPL;

public class Wrapper
{
	public static String prologue = 
		"let lookupInClass = recfun lookupInClass theClass methodname ->" +
		"						if theClass hasproperty methodname" +
		"						then theClass.methodname" +
		"						else (lookupInClass theClass.Parent methodname)" +
		"						end" +
		"					  end" +
		" in " +
		"	let new = fun theClass -> [Class: theClass] end " +
		"		lookup = fun object methodName -> object.Class.methodname end" +		
		" 	in ";
	
	public static String epilogue = " end end";
}
