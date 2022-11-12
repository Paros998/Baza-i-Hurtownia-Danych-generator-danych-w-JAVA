package pg.types;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Course {
    public static final String FILE = "courses.json";

    private String validTo;
    private String date;
    private String name;
}