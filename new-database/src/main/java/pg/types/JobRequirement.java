package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class JobRequirement {
    public static final String FILE = "job-requirements.json";

    private Integer experienceLevel;
    private String name;
}
