module Populator
  # This module adds several methods for generating random data which can be
  # called directly on Populator.
  module Random
    WORDS = %w(alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat)

    # Pick a random value out of a given range.
    def value_in_range(range)
      case range.first
      when Integer then number_in_range(range)
      when Time then time_in_range(range)
      when Date then date_in_range(range)
      else range.to_a[rand(range.to_a.size)]
      end
    end

    # Generate a given number of words. If a range is passed, it will generate
    # a random number of words within that range.
    def words(total)
      (1..interpret_value(total)).map { WORDS[rand(WORDS.size)] }.join(' ')
    end

    # Generate a given number of sentences. If a range is passed, it will generate
    # a random number of sentences within that range.
    def sentences(total)
      (1..interpret_value(total)).map do
        words(5..20).capitalize
      end.join('. ')
    end

    # Generate a given number of paragraphs. If a range is passed, it will generate
    # a random number of paragraphs within that range.
    def paragraphs(total)
      (1..interpret_value(total)).map do
        sentences(3..8).capitalize
      end.join("\n\n")
    end

    # If an array or range is passed, a random value will be selected to match.
    # All other values are simply returned.
    def interpret_value(value)
      case value
      when Array then value[rand(value.size)]
      when Range then value_in_range(value)
      else value
      end
    end

    private

    def time_in_range(range)
      Time.at number_in_range(Range.new(range.first.to_i, range.last.to_i, range.exclude_end?))
    end

    def date_in_range(range)
      Date.jd number_in_range(Range.new(range.first.jd, range.last.jd, range.exclude_end?))
    end

    def number_in_range(range)
      if range.exclude_end?
        rand(range.last - range.first) + range.first
      else
        rand((range.last+1) - range.first) + range.first
      end
    end
  end

  extend Random # load it into the populator module directly so we can call the methods
end
