package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Skill {
    public static final String FILE = "skills.json";

    private Integer level;
    private String name;
}
