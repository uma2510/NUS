package sVML;

public class NOT extends INSTRUCTION {
  public NOT() {
     OPCODE = OPCODES.NOT;
  }
  public String toString() {
     return "NOT";
  }
  public String toXML() {
     return "<svm:NOT/>";
  }
}
