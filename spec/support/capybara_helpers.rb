module CapybaraHelpers
  def have_bootstrap_select(*args)
    have_select(args.first, **args.last.merge(visible: false))
  end
end
