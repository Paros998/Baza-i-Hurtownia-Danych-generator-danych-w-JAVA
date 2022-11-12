package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Test {
    public static final String FILE = "qualification-tests.json";

    private String name;
    private Integer difficultyLevel;
}
