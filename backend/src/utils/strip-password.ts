type WithPassword = { password: string };
type WithUser = { user: WithPassword };
type WithOptionalUser = { user?: WithPassword | null };

export function stripUser<T extends WithPassword>(user: T): Omit<T, 'password'> {
  const { password: _pw, ...rest } = user;
  return rest;
}

export function stripNested<T extends WithUser>(obj: T): Omit<T, 'user'> & { user: Omit<T['user'], 'password'> } {
  return { ...obj, user: stripUser(obj.user) };
}

export function stripNestedOptional<T extends WithOptionalUser>(
  obj: T
): Omit<T, 'user'> & { user?: Omit<NonNullable<T['user']>, 'password'> | null } {
  if (!obj.user) return obj as never;
  return { ...obj, user: stripUser(obj.user) };
}
