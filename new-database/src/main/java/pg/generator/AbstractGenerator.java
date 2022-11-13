package pg.generator;

import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import com.thedeanda.lorem.Lorem;
import com.thedeanda.lorem.LoremIpsum;
import pg.utils.RandomUtil;

import java.time.Clock;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.function.Function;

@Slf4j
@NoArgsConstructor
public abstract class AbstractGenerator {
    protected static final Random rand = RandomUtil.random;
    protected static final Clock clock = RandomUtil.clock;
    protected static final DateTimeFormatter format1 = DateTimeFormatter.ofPattern("M/d/yyyy");
    protected static final DateTimeFormatter format2 = DateTimeFormatter.ofPattern("MM/dd/yyyy");
    protected static final Lorem lorem = LoremIpsum.getInstance();

    protected static <T, R> List<R> applyFunction(final Function<T, R> function, final T argument, final Integer maxRandom) {
        int numberOfExecutions = RandomUtil.intBetween(1, maxRandom);
        int currentExecution = 1;

        List<R> result = new ArrayList<>();

        do {
            result.add(function.apply(argument));
            currentExecution++;
        } while (currentExecution <= numberOfExecutions);

        return result;
    }

    protected static <T> T getRandomObject(final List<T> data) {
        return data.get(rand.nextInt(data.size()));
    }

    protected static LocalDate tryParse(final String date) {
        try {
            return LocalDate.parse(date, format1);
        } catch (DateTimeParseException e) {
            return LocalDate.parse(date, format2);
        }
    }

    public abstract void generateFacts(final Integer numberOfFacts);
}
