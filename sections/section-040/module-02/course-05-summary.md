# Summary

Well done, astronaut. You can now reshape whole fleets of data, call the right function on real policy values, and plan for the gaps. This page recaps each part, lists your mission, and shows you how to clean up.

## What you learned

**From [Shaping Lists And Objects](./course-01-shaping-lists-and-objects.md):**

- `[]` flattens a list of lists, `[0:2]` slices and `[-1]` counts from the end.
- `.*` and `keys(...)` list values and key names in no fixed order, so wrap them in `sort(...)`.
- `[x, y]` builds a list and `{n: x}` builds an object from each item.
- Keys with dots or slashes need double quotes.

**From [Sorting, Counting And Combining With Built-In Functions](./course-02-stock-functions-for-sorting-counting-and-combining.md):**

- `sort_by` and `max_by` take an expression that starts with `&`.
- `length`, `join`, `contains`, `starts_with`, `merge` and `to_string` cover most everyday needs.
- `&&`, `||` and `!` combine tests, and strings use single quotes while numbers use backticks.

**From [Kyverno Functions On Real Policy Data](./course-03-kyverno-functions-on-real-policy-data.md):**

- `parse_json` opens a string of JSON, and `base64_decode` reads an encoded value.
- `path_canonicalize` cleans a path, and `multiply`, `divide` and `add` keep quantity units.
- `time_since` and `time_add` work on moments and durations, and `object_from_lists` builds a lookup object.

**From [Defaults, Requests And Debugging Tools](./course-04-defaults-requests-and-debugging-tools.md):**

- `||` supplies a default for a missing key, and an out-of-range index gives `null`.
- `-q` reads the expression from a file, `-c` and `-u` change the output, and `kyverno jp parse` shows how the engine reads an expression.

## Your mission

| Mission | After the part | What you prove |
| --- | --- | --- |
| [Advanced JMESPath Lab](./labs/lab-01/README.md) | Defaults, Requests And Debugging Tools | pick, count and sort Pod data, open a token and a limit, and measure a start time |

If you have not done it yet, go back to it now.

## Clean up

First, see what is still running:

```sh
astrona list
```

Remove the playground by its **name**, not its folder path:

```sh
astrona destroy ats-009-playground-040-02
```

If the mission is still listed, remove it with `astrona destroy ats-009-lab-014`. Then run `astrona list` again. It should say `No astrona labs running.`

> *Test every expression on a whole fleet of sample data first: the policy will meet the same gaps in the cluster.*

<!-- astrona:playground:destroy -->
