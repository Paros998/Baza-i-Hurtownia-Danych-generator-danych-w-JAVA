package pg.utils;

import lombok.experimental.UtilityClass;

import java.time.Clock;
import java.util.Random;

@UtilityClass
public class RandomUtil {
    public final Clock clock = Clock.systemUTC();
    public final Random random = new Random(clock.millis());

    public Boolean getBoolean() {
        return random.nextInt(2) == 0;
    }

    public Integer intBetween(int min, int max) {
        return random.nextInt((max - min) + 1) + min;
    }
}
