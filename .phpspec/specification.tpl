<?php

declare(strict_types=1);

namespace %namespace%;

%imports%

/** @see %subject_class% */
final class %name% extends ObjectBehavior
{
    public function it_is_initializable(): void
    {
        $this->shouldHaveType(%subject_class%::class);
    }
}
