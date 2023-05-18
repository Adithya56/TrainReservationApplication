package Servlets_Demo;

public class Passenger {
	private String pname;
	private int age;
	private String gender;
	private double ticketCost;

	public Passenger(String pname, int age, String gender, double ticketCost) {
		this.pname = pname;
		this.age = age;
		this.gender = gender;
		this.ticketCost = ticketCost;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public double getTicketCost() {
		return ticketCost;
	}

	public void setTicketCost(double ticketCost) {
		this.ticketCost = ticketCost;
	}
}
