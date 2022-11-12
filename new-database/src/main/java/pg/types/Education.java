package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Education {
    public static final String FILE = "educations.json";

    private String since;
    private String schoolName;
    private String to;
}