import java.util.regex.MatchResult;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.google.common.base.Preconditions;

public class PatternDemo {
   private static final String REGEX = "[a-z0-9][a-z0-9-]*[a-z0-9]";
   private static final String INPUT = "us-west-prod-druid";
   public static final Pattern K8S_RESOURCE_NAME_REGEX = Pattern.compile("[a-z0-9][a-z0-9-]*[a-z0-9]");

   public static void main(String[] args) {
      // create a pattern
      Pattern pattern = Pattern.compile(REGEX);
      Preconditions.checkArgument(
         K8S_RESOURCE_NAME_REGEX.matcher(INPUT).matches(),
         "clusterIdentifier[%s] is used in k8s resource name and must match regex[%s]",
         INPUT,
         K8S_RESOURCE_NAME_REGEX.pattern()
     );
      // get a matcher object
      Matcher matcher = pattern.matcher(INPUT); 
      Boolean Result=K8S_RESOURCE_NAME_REGEX.matcher(INPUT).matches();
      if(matcher.find()) {
         //get the MatchResult Object 
         MatchResult result = matcher.toMatchResult();

         //Prints the offset after the last character matched.
         System.out.println("First Capturing Group - Match String end(): "+result.end());         
      }
      System.out.println("test"+Result);
   }
}
