package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Name {
    public static final String FILE = "names.json";

    private String firstName;
    private String lastName;
}
