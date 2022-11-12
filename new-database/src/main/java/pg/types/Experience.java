package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Experience {
    public static final String FILE = "experiences.json";

    private String companyName;
    private String to;
    private String vacancy;
    private String since;
}